import pandas as pd
import os
from datetime import datetime, timedelta

# Criar pasta 'ops' se não existir
os.makedirs('ops', exist_ok=True)

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

# 4. Tratando IDs e Datas
df_jogos['Match ID'] = df_jogos['Match ID'].astype(str).str.replace(r'\.0$', '', regex=True)
df_base['Match ID'] = df_base['Match ID'].astype(str).str.replace(r'\.0$', '', regex=True)
df_base['Date'] = pd.to_datetime(df_base['Date'], errors='coerce')

# --- NOVO: LÓGICA DE MÉDIAS POR LIGA ---
print("Calculando médias por liga...")

# Garantir colunas mínimas para não quebrar o cálculo
colunas_numericas = [
    'shoot_on_target_home', 'shoot_on_target_away', 'shoot_off_target_home', 'shoot_off_target_away',
    'TotalGoals_FT', 'Goals_H_FT', 'Goals_A_FT', 'Odd_A_FT', 'Odd_H_FT'
]
for col in colunas_numericas:
    if col in df_base.columns:
        df_base[col] = pd.to_numeric(df_base[col], errors='coerce').fillna(0)
    else:
        df_base[col] = 0

if 'is_cup' not in df_base.columns:
    df_base['is_cup'] = False

# Filtro últimos 365 dias (ou Copas)
cutoff = datetime.today() - timedelta(days=365)
df_league = df_base[ (df_base['Status'] == 'Full') & ( (df_base['is_cup']) | (~df_base['is_cup'] & (df_base['Date'] >= cutoff)) ) ].copy()

def agg_func(x):
    total = len(x)
    stats_true = x['Stats'].sum() if 'Stats' in x.columns else 0
    shots = ( x['shoot_on_target_home'] + x['shoot_on_target_away'] + x['shoot_off_target_home'] + x['shoot_off_target_away'] ).sum()
    goals_league = x['TotalGoals_FT'].sum()
    goals = x['TotalGoals_FT']
    goals_total = x['TotalGoals_FT'].mean()
    goals_h = x['Goals_H_FT'].mean()
    goals_a = x['Goals_A_FT'].mean()
    goal_asymmetry = abs(goals_h - goals_a)
    conversion_rate = goals_league / shots if shots > 0 else 0

    btts = ((x['Goals_H_FT'] > 0) & (x['Goals_A_FT'] > 0)).sum() / total if total else 0
    no_goal_rate = ((x['Goals_H_FT'] == 0) | (x['Goals_A_FT'] == 0)).sum() / total
    home_bias = goals_h / (goals_total + 1e-6)

    zebra_a = x[x['Odd_A_FT'] > 5]
    zebra_a_total = len(zebra_a)
    zebra_a_score = (zebra_a['Goals_A_FT'] > 0).sum() / zebra_a_total if zebra_a_total else 0

    zebra_h = x[x['Odd_H_FT'] > 5]
    zebra_h_total = len(zebra_h)
    zebra_h_score = (zebra_h['Goals_H_FT'] > 0).sum() / zebra_h_total if zebra_h_total else 0

    zebra_index = (zebra_a_score + zebra_h_score) / 2
    media_goals = goals.mean()
    std_goals = goals.std()
    cv_goals = std_goals / media_goals if media_goals else 0
    open_game_index = goals_total * (1 - cv_goals)

    return pd.Series({
        'qtd_jogos': total,
        'qtd_stats_true': stats_true,
        'media_goals_total_ft': goals_total,
        'cv_goals_total': cv_goals,
        'conv_rate': conversion_rate,
        'goal_asymmetry': goal_asymmetry,
        'open_game_index': open_game_index,
        'media_goals_home_ft': goals_h,
        'media_goals_away_ft': goals_a,
        'home_bias': home_bias,
        'freq_btts': btts,
        'freq_no_goal': no_goal_rate,
        'qtd_zebra_away': zebra_a_total,
        'freq_zebra_away_score': zebra_a_score,
        'qtd_zebra_home': zebra_h_total,
        'freq_zebra_home_score': zebra_h_score,
        'zebra_index': zebra_index
    })

resultado_meio = df_league.groupby(['League', 'country']).apply(agg_func).reset_index()
resultado_meio = resultado_meio[resultado_meio['qtd_jogos'] >= 10].sort_values(by='qtd_jogos', ascending=False).round(2)

# Salva o resultado das médias
resultado_meio.to_csv("ops/leagues_mean.csv", sep=';', index=False, decimal=',', encoding='utf-8-sig')
print(f"✅ Médias de {len(resultado_meio)} ligas geradas.")

# --- CONTINUAÇÃO DO SCRIPT ORIGINAL (Filtros e Pendentes) ---

# 5. Filtro de ligas (Remover lixos)
termos_proibidos = ['Beach Soccer', 'Mins', 'Kings League', 'Esoccer']
df_jogos_filtrado = df_jogos[~df_jogos['League'].str.contains('|'.join(termos_proibidos), case=False, na=False)].copy()

# 6. Gerando Pendentes
ids_base = set(df_base['Match ID'])
faltantes = df_jogos_filtrado[~df_jogos_filtrado['Match ID'].isin(ids_base)].copy()

if not faltantes.empty:
    faltantes.to_csv("ops/pendentes.csv", index=False, encoding='utf-8')
    print(f"✅ {len(faltantes)} jogos pendentes salvos.")

# 7. Comparação de Nomes (Times)
df_comp = pd.merge(df_jogos_filtrado[['Match ID', 'Home Team', 'Away Team']], 
                   df_base[['Match ID', 'Home Team', 'Away Team']], 
                   on='Match ID', suffixes=('_jogos', '_base'))

div_h = df_comp[df_comp['Home Team_jogos'] != df_comp['Home Team_base']][['Home Team_base', 'Home Team_jogos']].rename(columns={'Home Team_base':'de','Home Team_jogos':'para'})
div_a = df_comp[df_comp['Away Team_jogos'] != df_comp['Away Team_base']][['Away Team_base', 'Away Team_jogos']].rename(columns={'Away Team_base':'de','Away Team_jogos':'para'})

df_times = pd.concat([div_h, div_a]).drop_duplicates().sort_values(by='de')
df_times.to_csv("ops/mapeamento_times_tc.csv", index=False, encoding='utf-8-sig')

# 8. Comparação de Ligas
df_l = pd.merge(df_jogos_filtrado[['Match ID', 'League']], 
                df_base[['Match ID', 'League']], 
                on='Match ID', suffixes=('_jogos', '_base'))

div_l = df_l[df_l['League_jogos'] != df_l['League_base']].copy()
df_l_final = div_l[['Match ID', 'League_base', 'League_jogos']].rename(
    columns={'League_base': 'liga_original', 'League_jogos': 'liga_nova'}
)
df_l_final.to_csv("ops/mapeamento_ligas_tc.csv", index=False, encoding='utf-8-sig')

print(f"🚀 Mapeamento de ligas gerado com {len(df_l_final)} divergências.")
print("📂 Todos os arquivos gerados na pasta /ops")