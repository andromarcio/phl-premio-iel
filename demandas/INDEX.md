<!-- docqui: 2.8.0 | prompt: PROMPT_BACKLOG | atualizado: 2026-09-01 -->
# Demandas atendidas
> Índice das demandas do Prêmio IEL de Talentos, com a análise de impacto de cada uma.

Cada demanda da ferramenta de origem tem **um arquivo neste diretório**, nomeado pela sua chave em minúsculas. O arquivo reúne a demanda como ela chegou, os critérios de aceite, as features (N3) que a realizam e o que ela fez na especificação. Modelo em [`_template-demanda.md`](./_template-demanda.md).

> **Não há Ponto de Função nestes arquivos, por regra.** A função — processo elementar ou função de dados — conta uma vez por projeto de melhoria, ainda que alterada por demandas diferentes, e o CHGA é medido sobre o estado final. A contagem é feita no fechamento da sprint, sobre os artefatos já consolidados.

---

## Demandas registradas

**Nenhuma ainda por arquivo.** Este diretório foi criado na migração que aposentou `modules/_backlog/`; o registro de impacto desta instância é hoje **por sprint**, não por demanda — ver a seção abaixo.

Esta instância trabalha com **duas chaves que convivem**, como descreve o `global/MASTER.md`: a demanda nasce como **História de Usuário** em `.docx` (`arquivos/HU-0NN_*.docx`), que diz *o que* foi pedido e é o elo com a spec, e é planejada como **item de trabalho no Jira**, no board `PDTIC25093`, que diz *em que sprint* entrou e é o elo com a contagem.

⚠️ **Decisão em aberto: qual chave nomeia o arquivo aqui.** A convenção do framework é um arquivo por chave da ferramenta de origem — o que apontaria para `pdtic25093-49.md`. Mas é a HU que carrega os critérios de aceite, e um item do Jira pode cobrir mais de uma HU (e vice-versa), então nomear pela HU (`hu-030-fechar-etapa.md`) também se defende. A SP05 já mapeia os dois lados: `PDTIC25093-49`, `-56`, `-58`, `-60`, `-61`, `-66`, `-67` e `-68`, cada um ligado à sua HU no relatório abaixo.

---

## Análises de impacto por sprint

Enquanto não há demanda por chave, o registro de impacto desta instância é por **sprint**, em [`arquivos/demandas/`](../arquivos/demandas/):

| Documento | O que é |
|---|---|
| [Relatório de Impacto — SP05](../arquivos/demandas/ANALISE_IMPACTO_SP05.md) | O que a Sprint 5 mudou na especificação, no roteiro de 5 seções: detalhe por item · alterações aplicadas · tabelas por função de dados · dicionários · decisões pendentes |
| [Análise SP05 — novas vs. alteradas](../arquivos/demandas/ANALISE_SP05_novas_vs_alteradas.md) | O insumo do relatório: a classificação item a item da demanda |
| [Questionamento à equipe de métricas](../arquivos/demandas/QUESTIONAMENTO_METRICAS_BASELINE_APF.md) | As perguntas de contagem levantadas pelo baseline APF |

---

## Como registrar uma demanda nova

1. Copie [`_template-demanda.md`](./_template-demanda.md) para `demandas/<chave-em-minúsculas>.md`.
2. Preencha a demanda e os critérios a partir da fonte — **sem inventar numeração**: se a fonte não numera os critérios, não há `CA-n` e a rastreabilidade fica só pela chave.
3. Registre as features que a realizam e feche o elo recíproco na seção `## Origem` de cada N3. Confira com `node scripts/audit-trace-links.mjs --root .`.
4. Acrescente a linha na tabela acima.

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Claude | Índice criado | Diretório `demandas/` criado na migração que aposentou `modules/_backlog/`; sem demanda por chave nesta instância, cujo backlog são as HUs em `.docx` |
