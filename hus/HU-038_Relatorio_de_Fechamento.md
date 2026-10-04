# HU-038 — Relatório de Fechamento da Etapa

> **Projeto:** Prêmio IEL de Talentos · **Cliente:** Confederação Nacional das Indústrias
> **Spec docqui:** [`AVL-RES-01` — Fechar Etapa de Avaliação](../modules/avaliacao/apuracao-consulta-resultados/f-fechar-etapa-avaliacao.md) (transação "Exportar Relatório da Etapa")

## Histórico de revisão

| Data | Autor | Descrição | HU |
|---|---|---|---|
| 20/08/2026 | Claude (docbot) | Versão inicial gerada a partir da análise do código-fonte (tela `avaliacao-admin/fechamento-etapa` e `RelatorioEtapaService`), fundamentada na especificação docqui AVL-RES-01. | HU-038 |

## Introdução

Esta história descreve o Relatório de Fechamento da Etapa: a exportação, em planilha Excel (XLSX), do resultado consolidado de uma etapa da premiação. O relatório é disparado a partir da tela de Fechamento de Etapa (`avaliacao-admin/fechamento-etapa`) e reúne, em uma aba de Resumo e em uma aba por tipo de participante, o rastreio completo de cada inscrição: dados cadastrais, respostas do formulário de inscrição, notas por avaliador, feedback consolidado e a decisão de corte (classificação e premiação).

## Objetivo

**Sendo** Administrador Nacional (ou Administrador Regional, no escopo dos seus estados), **acessando** a tela de Fechamento de Etapa, após selecionar uma premiação e uma etapa, **posso** exportar o relatório consolidado da etapa em uma planilha Excel (XLSX), **para** auditar, conferir e arquivar oficialmente o resultado da etapa — quem classifica, quem é premiado, as notas de cada avaliador e o feedback consolidado de cada inscrição.

## Cenários

### Sucesso

- **Exportar o relatório de uma etapa com resultado apurado** — Dado que o Administrador selecionou uma premiação e uma etapa com inscrições elegíveis ao ranking, quando ele clica no botão "Relatório da etapa (XLSX)" na barra superior da tela de Fechamento de Etapa, então o sistema gera e baixa o arquivo `relatorio-etapa.xlsx`, com a aba "Resumo" (uma linha por estado × grupo) e uma aba por tipo de participante com o rastreio por inscrição.
- **Botão de exportação indisponível enquanto não há etapa selecionada** — Dado que o Administrador ainda não selecionou uma etapa (ou o resumo do ranking ainda está carregando), o botão "Relatório da etapa (XLSX)" permanece desabilitado; ele só é habilitado após a seleção de uma etapa e o carregamento do resumo do ranking.
- **Indicador de progresso durante a geração** — Dado que o Administrador clicou em "Relatório da etapa (XLSX)", enquanto o sistema monta a planilha o botão exibe um indicador de carregamento; ao concluir, o indicador desaparece e o arquivo é baixado automaticamente.
- **Aba de resumo consolida participações, classificados e premiados por estado e grupo** — Cada linha da aba "Resumo" traz Estado, Grupo, Participantes, Classificados, Premiados, Estado fechado em e Fechado por; a coluna Premiados fica em branco quando a etapa não premia, e as colunas de fechamento só são preenchidas para estados já fechados.
- **Identidade do avaliador ocultada em premiação confidencial** — Em premiação confidencial (ou sem essa configuração resolvida), o nome do avaliador é substituído por um rótulo genérico ("Avaliador 1", "Avaliador 2", ...); o nome real só aparece quando a premiação está explicitamente marcada como não confidencial.
- **Administrador Regional exporta apenas os estados do seu escopo** — Dado o perfil Administrador Regional com escopo restrito, a planilha contém somente as inscrições dos estados sob o seu escopo de UF, recorte aplicado no servidor sobre a mesma fonte de dados do ranking.

### Exceção

- **Etapa sem inscrições elegíveis** — Dada uma etapa sem inscrições elegíveis, o sistema gera uma planilha com uma única aba "Sem resultados" contendo a mensagem "Nenhuma inscrição encontrada para esta etapa."
- **Falha ao gerar o relatório** — Dado um erro no servidor ao montar a planilha, o sistema não baixa arquivo e exibe "Erro ao gerar o relatório da etapa."; o indicador de carregamento é encerrado, permitindo nova tentativa.

## Regras de negócio

| ID | Descrição |
|---|---|
| RN1 | O relatório é gerado sempre a partir do ranking já apurado da etapa: o corte de classificação e de premiação e o recorte de UF do Administrador Regional são aplicados na fonte de dados — o relatório apenas consome e enriquece esse resultado, jamais recalcula corte ou escopo. |
| RN2 | A planilha é composta por uma aba "Resumo" (uma linha por estado × grupo competitivo) e por uma aba para cada tipo de participante presente na etapa, ordenadas pelo nome do tipo. |
| RN3 | A aba Resumo apresenta, por estado e grupo: Estado, Grupo, Participantes, Classificados, Premiados, Estado fechado em e Fechado por. |
| RN4 | As colunas de premiação (Premiados/Premiado) só são preenchidas quando a etapa define uma quantidade de premiados; caso contrário, ficam em branco. |
| RN5 | As colunas Estado fechado em e Fechado por só têm valor para estados (UF) já fechados; para estados ainda em apuração ficam vazias. |
| RN6 | Cada aba de tipo de participante traz, por inscrição, as colunas fixas: Protocolo, Participante, E-mail, UF, Grupo, Início, Finalização, Média final, Classificado, Premiado, Feedback consolidado, Consolidado em, Consolidado por e Estado fechado em. |
| RN7 | Após as colunas fixas, a aba de cada tipo inclui dinamicamente uma coluna para cada campo do formulário de inscrição daquele tipo de participante. |
| RN8 | Para cada avaliador alocado à inscrição, a aba acrescenta um bloco de quatro colunas: avaliador (nome ou rótulo), status da avaliação, nota (média ponderada do avaliador) e data de finalização; o número de blocos acompanha a inscrição com mais avaliadores da aba. |
| RN9 | A nota de cada avaliador é a média das notas cruas ponderada pelos pesos das questões, multiplicada pelo fator de pontuação da premiação e arredondada em duas casas decimais. |
| RN10 | Em premiação confidencial (ou configuração não resolvida), a identidade do avaliador é anonimizada como "Avaliador K"; o nome real só é exibido quando a premiação está explicitamente marcada como não confidencial (fail-closed). |
| RN11 | Quando a etapa não possui inscrições elegíveis, a planilha contém apenas a aba "Sem resultados" com a mensagem correspondente. |
| RN12 | O Administrador Regional recebe apenas as inscrições dos estados do seu escopo de UF; o Administrador Nacional recebe todos os estados da etapa. |
| RN13 | O botão de exportação só fica habilitado após uma etapa ter sido selecionada e o resumo do ranking ter terminado de carregar. |
| RN14 | O arquivo gerado é baixado com o nome `relatorio-etapa.xlsx` no formato Excel (XLSX). |

## Telas

A funcionalidade não possui tela própria: o Relatório de Fechamento é acionado pelo botão "Relatório da etapa (XLSX)", posicionado na barra superior (toolbar) da tela de Fechamento de Etapa (rota `avaliacao-admin/fechamento-etapa/:etapaId`). O botão permanece desabilitado até que uma etapa seja selecionada e o resumo do ranking seja carregado, e exibe um indicador de carregamento durante a geração.

Estrutura da planilha `relatorio-etapa.xlsx`:

- **Aba "Resumo"** — uma linha por estado (UF) × grupo competitivo. Colunas: Estado, Grupo, Participantes, Classificados, Premiados, Estado fechado em, Fechado por.
- **Uma aba por tipo de participante** (ordenadas pelo nome do tipo) — uma linha por inscrição. Colunas fixas: Protocolo, Participante, E-mail, UF, Grupo, Início, Finalização, Média final, Classificado, Premiado, Feedback consolidado, Consolidado em, Consolidado por, Estado fechado em. Em seguida, uma coluna por campo do formulário de inscrição do tipo. Ao final, para cada avaliador: Avaliador K, Avaliador K — status, Avaliador K — nota, Avaliador K — finalização.
- **Aba "Sem resultados"** — exibida no lugar das demais quando a etapa não tem inscrições elegíveis, com a mensagem "Nenhuma inscrição encontrada para esta etapa."

## Campos (contexto de acionamento)

| Campo | Descrição | Obrigatório | Tipo | Regra |
|---|---|---|---|---|
| Premiação | Pré-requisito: premiação selecionada na tela de Fechamento de Etapa. | Sim | Seleção | Filtro por nome; ao selecionar, carrega as etapas da premiação. |
| Etapa | Pré-requisito: etapa selecionada cujo resultado será exportado. | Sim | Seleção | Habilitada somente após a seleção da premiação; a exportação usa o identificador desta etapa. |
| Relatório da etapa (XLSX) | Botão que dispara a geração e o download da planilha. | - | Botão / Ação | Habilitado apenas com etapa selecionada e resumo do ranking carregado; exibe indicador de carregamento; baixa `relatorio-etapa.xlsx`. |

## Critérios de aceite

1. O botão "Relatório da etapa (XLSX)" fica desabilitado enquanto não houver etapa selecionada ou enquanto o resumo do ranking estiver carregando.
2. Ao acionar a exportação de uma etapa com inscrições, o sistema baixa `relatorio-etapa.xlsx` com a aba Resumo e uma aba por tipo de participante.
3. A aba Resumo apresenta uma linha por estado × grupo, com participantes, classificados, premiados e os dados de fechamento (quando o estado está fechado).
4. Cada aba de tipo de participante lista, por inscrição, os dados cadastrais, respostas do formulário, notas por avaliador, feedback consolidado e a decisão de corte.
5. As colunas de premiação só são preenchidas quando a etapa define quantidade de premiados.
6. Em premiação confidencial, a identidade dos avaliadores é substituída por rótulos genéricos.
7. O Administrador Regional recebe apenas as inscrições dos estados do seu escopo de UF.
8. Quando a etapa não tem inscrições elegíveis, o relatório traz apenas a aba "Sem resultados".
9. Falhas na geração exibem "Erro ao gerar o relatório da etapa." sem baixar arquivo, permitindo nova tentativa.

## Perfis e permissões

| Perfil | Visualizar | Criar | Editar | Excluir |
|---|---|---|---|---|
| Administrador Nacional (PIT.1) | X | - | - | - |
| Administrador Regional (PIT.3) | X | - | - | - |
| Avaliador | - | - | - | - |
| Participante (Candidato) | - | - | - | - |

## Outras informações

**Endpoints:**
- `GET /administracao/avaliacao/fechamento/etapas/{etapaId}/relatorio-etapa/exportar` — gera e retorna a planilha XLSX (`Content-Disposition: attachment; filename=relatorio-etapa.xlsx`). Erros: 400 (etapaId inválido), 403 (capability/escopo de UF), 500 (falha na geração).
- `GET /administracao/avaliacao/fechamento/etapas/{etapaId}/ranking` — fonte de dados do relatório (corte e recorte de UF já aplicados).

**Principais tabelas:** `TB_INSCRICAO`, `TB_INSCRICAO_RESPOSTA`, `TB_INSCRICAO_DOCUMENTO`, `TB_ALOCACAO_AVALIADOR_PARTICIPANTE`, `TB_AVALIACAO_NOTA`, `TB_APROVACAO_ETAPA_PARTICIPANTE`, `TB_FECHAMENTO_ETAPA_UF`, `TB_PREMIACAO`.

**Integrações:** geração de planilha XLSX via Apache POI (`SXSSFWorkbook`, streaming com janela de 100 linhas). O relatório reaproveita o serviço de ranking do fechamento de etapa como fonte única de dados escopados, garantindo consistência com a tela de Fechamento e evitando reimplementar corte/escopo.

**Fundamentação no código (engenharia reversa):**
- Frontend — `premio-iel-angular/src/app/modules/avaliacao-admin/pages/fechamento-etapa/fechamento-etapa.component.ts:440` (`exportarRelatorio()`) e `.html:9` (botão "Relatório da etapa (XLSX)"); `configuracao-premiacao/services/fechamento-etapa.service.ts` (`exportarRelatorioEtapa()`).
- Backend — `premio-iel-java/.../controller/FechamentoEtapaController.java:80` (`exportarRelatorioEtapa`) e `service/impl/RelatorioEtapaServiceImpl.java` (montagem das abas, colunas fixas/dinâmicas, cálculo da média e regra de confidencialidade).
- Rota restrita — `avaliacao-admin-routing.module.ts:41` (`fechamento-etapa` restrito a `ADMIN_NACIONAL`); o endpoint de exportação não possui guard de perfil e admite PIT.3 com recorte de UF.
