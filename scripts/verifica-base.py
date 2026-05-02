import pandas as pd
import os

# Criar pasta complementos se não existir
os.makedirs('complementos', exist_ok=True)

# 1. URLs dos arquivos
urls_jogos = [
    "https://raw.githubusercontent.com/gatodegravata/vulp-stats/main/lists/jogos_2024_tc.csv",
    "https://raw.githubusercontent.com/gatodegravata/vulp-stats/main/lists/jogos_2025_tc.csv",
    "https://raw.githubusercontent.com/gatodegravata/vulp-stats/main/lists/jogos_2026_tc.csv"
]
url_base = "https://raw.githubusercontent.com/gatodegravata/vulp-stats/main/base/db_matches.parquet"

print("Iniciando processamento...")

# 2. Consolidando CSVs
lista_df = []
for url in urls_jogos:
    try:
        lista_df.append(pd.read_csv(url))
    except:
        pass
df_jogos = pd.concat(lista_df, ignore_index=True)

# 3. Base Parquet
df_base = pd.read_parquet(url_base)

# 4. Tratando IDs
df_jogos['Match ID'] = df_jogos['Match ID'].astype(str).str.replace(r'\.0$', '', regex=True)
df_base['Match ID'] = df_base['Match ID'].astype(str).str.replace(r'\.0$', '', regex=True)

# 5. Filtro de ligas (Remover Esoccer e outros lixos)
termos_proibidos = ['Beach Soccer', 'Mins', 'Kings League', 'Esoccer']
df_jogos_filtrado = df_jogos[~df_jogos['League'].str.contains('|'.join(termos_proibidos), case=False, na=False)].copy()

# 6. Gerando Pendentes (Jogos novos)
ids_base = set(df_base['Match ID'])
faltantes = df_jogos_filtrado[~df_jogos_filtrado['Match ID'].isin(ids_base)].copy()

if not faltantes.empty:
    faltantes.to_csv("complementos/pendentes.csv", index=False, encoding='utf-8')
    print(f"✅ {len(faltantes)} jogos pendentes salvos.")

# 7. Comparação de Nomes (Times) - Mantido dicionário geral
df_comp = pd.merge(df_jogos_filtrado[['Match ID', 'Home Team', 'Away Team']], 
                   df_base[['Match ID', 'Home Team', 'Away Team']], 
                   on='Match ID', suffixes=('_jogos', '_base'))

div_h = df_comp[df_comp['Home Team_jogos'] != df_comp['Home Team_base']][['Home Team_base', 'Home Team_jogos']].rename(columns={'Home Team_base':'de','Home Team_jogos':'para'})
div_a = df_comp[df_comp['Away Team_jogos'] != df_comp['Away Team_base']][['Away Team_base', 'Away Team_jogos']].rename(columns={'Away Team_base':'de','Away Team_jogos':'para'})

df_times = pd.concat([div_h, div_a]).drop_duplicates().sort_values(by='de')
df_times.to_csv("complementos/mapeamento_times_tc.csv", index=False, encoding='utf-8-sig')

# 8. Comparação de Ligas (Agora com Match ID para atualização linha a linha)
df_l = pd.merge(df_jogos_filtrado[['Match ID', 'League']], 
                df_base[['Match ID', 'League']], 
                on='Match ID', suffixes=('_jogos', '_base'))

# Filtramos onde a liga é diferente
div_l = df_l[df_l['League_jogos'] != df_l['League_base']].copy()

# Renomeamos para ficar claro: Match ID, Liga Atual na Base, Liga Nova no TC
df_l_final = div_l[['Match ID', 'League_base', 'League_jogos']].rename(
    columns={'League_base': 'liga_original', 'League_jogos': 'liga_nova'}
)

# Salvamos o arquivo de atualização cirúrgica
df_l_final.to_csv("complementos/mapeamento_ligas_tc.csv", index=False, encoding='utf-8-sig')

print(f"🚀 Mapeamento de ligas gerado com {len(df_l_final)} divergências pontuais.")
print("📂 Todos os arquivos gerados na pasta /complementos")