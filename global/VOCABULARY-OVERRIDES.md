<!-- docqui: 4.1.0 | prompt: PROMPT_3A | atualizado: 2026-10-04 -->
# VOCABULARY-OVERRIDES.md — ajustes de vocabulário desta instância

> Ajusta o vocabulário canônico do framework (`engine/FEATURE-DEFINITION.md`) **para esta instância**, sem editar o engine. Lido automaticamente pelo gate semântico (`scripts/validate-feature-semantics.mjs`) — as tabelas abaixo são **máquina-legíveis** (primeira coluna = termo, grafia sem acento, como nas tabelas do engine).
>
> Um termo não é técnico ou negocial *por natureza* — depende do produto (Regra 10 da skill): `cache` vaza camada técnica num CRM, mas é a entidade central de um pipeline de ML. **Todo termo liberado exige justificativa** na segunda coluna — o gate não julga o motivo; quem confere é o revisor humano do PR que alterar este arquivo.
>
> Mantenha este arquivo **enxuto**: cada linha aqui é uma exceção ao contrato do framework. Se a exceção vale para qualquer produto do mesmo tipo, proponha a mudança no próprio `FEATURE-DEFINITION.md` do engine (via CHANGELOG) em vez de acumulá-la aqui.

---

## Verbos adicionais da instância

<!--
  Verbos no infinitivo que são ações de negócio DESTE produto e ainda não constam do
  vocabulário canônico. Efeito: FD-1 passa sem aviso; o verbo conta para a checagem de
  atomicidade (FD-3). Grafia kebab-case sem acento (como `lancar` no engine).
-->

| Verbo | Justificativa (ação de negócio deste produto) |
|---|---|
| reabrir | Ato administrativo próprio da premiação: devolver à apuração um escopo cuja etapa já foi encerrada, desfazendo o fechamento e os cortes daquele escopo. Não é `editar` (nada é alterado) nem `excluir` (o que se apaga é o registro do fechamento, não a etapa); é o inverso declarado de `encerrar`, e é o termo usado na interface e na demanda. Ver `AVL-APU-12` e `AVL-AVA-05` |
| desclassificar | Ato administrativo próprio da premiação: retirar uma inscrição da disputa de uma etapa, com justificativa registrada, sem apagar a inscrição nem a sua avaliação. Não é `rejeitar` (decisão de validação sobre a inscrição, anterior à avaliação) nem `excluir` (nada é removido); a inscrição continua existindo, com as notas que recebeu, apenas fora da disputa. É o termo da interface e do resumo de entrega. A reversão é a volta do mesmo estado binário e vive na mesma feature. Ver `AVL-APU-13` |
| conferir | Ato próprio do validador na premiação: marcar, item a item, quais dos ajustes solicitados ao participante já foram atendidos. É o termo que a interface e as histórias de usuário usam ("itens conferidos", "conferência"), e é distinto de `validar` (decisão sobre a inscrição inteira) e de `verificar` (checagem automática). Ver `VAL-AJU-04` |

---

## Termos liberados na posição do verbo

<!--
  Termos da tabela "Termos bloqueados na posição do verbo" do engine que NESTA
  instância nomeiam uma ação legítima. Use com parcimônia — o bloqueio quase sempre
  está certo; libere apenas quando o termo é genuinamente o nome da ação no domínio.
-->

| Termo | Justificativa |
|---|---|
| — | *(nenhum termo liberado nesta instância)* |

---

## Termos liberados na Descrição

<!--
  Termos da tabela "Termos proibidos na Descrição" do engine que NESTE produto são
  entidade/conceito de domínio (não vazamento técnico). Ex. clássico: `cache` num
  sistema de ML cujo produto é construir e consumir um cache de dados de treino.
-->

| Termo | Justificativa (entidade de domínio deste produto) |
|---|---|
| — | *(nenhum termo liberado nesta instância)* |

---

## Termos adicionais proibidos na Descrição

<!--
  Termos que NESTA instância denunciam vazamento técnico ou vagueza e devem reprovar
  a Descrição do N3, além dos já proibidos pelo engine. Mesmo formato da tabela do
  engine: tipo = `vago` | `tecnico`; a orientação diz o que escrever no lugar.
-->

| Termo | Tipo | Orientação |
|---|---|---|
| — | — | *(nenhum termo adicional proibido nesta instância)* |

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Arquivo regenerado do template 4.1.0, com os comentários-guia de cada tabela e a tabela de termos adicionais proibidos no formato Termo · Tipo · Orientação; os verbos `reabrir`, `desclassificar` e `conferir` mantidos |
| 2026-08-28 | Conferência doc × código (docqui) | Arquivo criado | Verbo `conferir` acrescentado ao vocabulário da instância, para a feature `VAL-AJU-04` |
