<!-- docqui: 2.16.0 | prompt: PROMPT_PROTOTYPE_FLOW_FULL | atualizado: 2026-09-02 -->
# Protótipos — Manifesto de fidelidade e aprovação
> Fonte de verdade do vínculo **protótipo ↔ N3**, do nível de **fidelidade** e do
> **status de aprovação**. Uma tela com fidelidade **obrigatória** só vira **contrato
> de implementação** quando o protótipo está **aprovado** aqui (com quem e quando).

| Protótipo | Feature (N3) | Fidelidade | Status | Aprovado por | Data |
|---|---|---|---|---|---|
| [prototypes/configuracao/categorias/](./configuracao/categorias/) | `CFG-CAT-01..05` | referência | rascunho | — | — |
| [prototypes/avaliacao/etapas-configuracao/](./avaliacao/etapas-configuracao/) | `AVL-ETA-01..03` | referência | rascunho | — | — |
| [prototypes/avaliacao/alocacao/](./avaliacao/alocacao/) | `AVL-ALO-01`, `AVL-ALO-02`, `AVL-ALO-04` | referência | rascunho | — | — |
| [prototypes/avaliacao/avaliacao-projetos/](./avaliacao/avaliacao-projetos/) | `AVL-AVA-01..04` | referência | rascunho | — | — |
| [prototypes/avaliacao/painel-administrativo/](./avaliacao/painel-administrativo/) | `AVL-PAI-01..04` | referência | rascunho | — | — |
| [prototypes/avaliacao/apuracao-devolutiva/](./avaliacao/apuracao-devolutiva/) *(flow-fechamento)* | `AVL-APU-01..03`, `AVL-APU-08`, `AVL-APU-09`, `AVL-APU-12` | referência | rascunho | — | — |
| [prototypes/avaliacao/apuracao-devolutiva/](./avaliacao/apuracao-devolutiva/) *(flow-relatorios)* | `AVL-APU-06`, `AVL-APU-10` | referência | rascunho | — | — |
| [prototypes/inscricao/acompanhamento/](./inscricao/acompanhamento/) | `INS-ACO-02` (contexto: `INS-ACO-01`) | referência | rascunho | — | — |
| [prototypes/validacao/fila-validacao/](./validacao/fila-validacao/) | `VAL-FIL-01..03` | referência | rascunho | — | — |
| [prototypes/validacao/analise-decisao/](./validacao/analise-decisao/) | `VAL-ANA-01..05`, `VAL-AJU-04` | referência | rascunho | — | — |

> ✅ **Conferidos com o código em 2026-08-28.** Os 9 protótipos tiveram as **rotas** trocadas pelas rotas reais da SPA e os **perfis** anotados com os códigos do portal corporativo (`PIT.1` Administrador Nacional · `PIT.2` Participante · `PIT.3` Administrador Regional · `PIT.4` Avaliador). Cada arquivo abre com uma faixa apontando este estado.
>
> ⚠️ **Features novas sem protótipo.** As 16 features criadas na conferência de 2026-08-28 (ver `global/CONFORMIDADE-CODIGO.md` § 4) entraram com fidelidade **n/a**, exceto duas já cobertas pelos fluxos existentes: `AVL-APU-08` (Consultar Ranking da Etapa), no *flow-fechamento*, e `VAL-AJU-04` (Conferir Item de Ajuste), no fluxo de Análise e Decisão. As demais — inclusive `AVL-ALO-05`, `AVL-ALO-07`, `AVL-AVA-06` e `AVL-AVA-07` — **não estão desenhadas em nenhum protótipo**, e os N3 delas dizem isso explicitamente. *(`AVL-PAI-04` saiu dessa lista em 2026-09-02 — ver abaixo.)*
>
> ✅ **2026-09-01.** As duas features especificadas nessa data entraram nos fluxos que já cobrem as suas telas, em vez de ganhar arquivo próprio: `AVL-APU-12` **Reabrir Etapa por UF** no *flow-fechamento* (ação de reabrir em cada bloco fechado, com a confirmação que anuncia o apagamento do registro) e `VAL-FIL-03` **Exportar Histórico do Painel de Validação** no fluxo da Fila (a tela do histórico exportado, que existia como ação de `VAL-FIL-02`, foi reatribuída à feature própria).
>
> ✅ **2026-09-02 — as cinco features da SP05 que faltavam foram desenhadas.** Nenhuma ganhou arquivo próprio: todas entraram no fluxo que já cobre a tela de onde a ação parte. `AVL-APU-10` **Gerar Relatório de Inscrições** e `AVL-APU-09` **Exportar Relatório da Etapa** como telas novas do *flow-relatorios* e do *flow-fechamento*; `AVL-PAI-04` **Exportar Relatório de Avaliadores** como a planilha do Painel Administrativo; `VAL-ANA-05` **Editar Inscrição Validada** como o modal de correção administrativa, que só aparece com a inscrição já validada. A exceção é `INS-ACO-02` **Visualizar Devolutiva**, que estreia o fluxo `inscricao/acompanhamento/` — a jornada do participante não tinha protótipo algum, e a devolutiva não se entende fora do painel que a hospeda (`INS-ACO-01` entra como contexto). Com isso **toda feature da SP05 está desenhada e especificada**.
>
> ✅ **2026-09-02 — cada tela passa a declarar a sua funcionalidade.** O botão da barra `.proto-bar` carrega `data-feature` com o ID (ou os IDs) da feature a que a tela pertence, e é dele que a Especificação Funcional (`.docx`) tira em qual capítulo desenhar cada tela. Antes as telas iam todas para um capítulo do Feature Set, longe da funcionalidade que especificam. Tela que serve a mais de uma feature aparece em todas — a de Detalhe da Inscrição, por exemplo, é onde `VAL-ANA-01` — Detalhar Inscrição, `VAL-ANA-02` — Iniciar Validação, `VAL-ANA-03` — Aprovar Inscrição e `VAL-ANA-04` — Rejeitar Inscrição acontecem. Tela que existe só para explicar a navegação leva `data-doc="nao"` e fica fora do documento.
>
> ⚠️ **O que ainda não foi refeito.** A arquitetura de navegação da **configuração da premiação** difere do que os protótipos e os N2 desenham: na implementação é **uma única tela** (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar`) com uma **árvore de estrutura** à esquerda — Premiação › Categoria › Modalidade › Tipo de Participante — e um **editor contextual** à direita, cujas abas variam com o nó selecionado (Premiação: *Dados* · *Termos & E-mails* · *Avaliação & Etapas*; Tipo de Participante: *Geral* · *Formulário de Inscrição* · *Sub Modalidades* · *Equipe* · *Anexos* · *Avaliação*). Redesenhar os fluxos afetados nesse formato é trabalho de design a decidir com o time — ver `global/CONFORMIDADE-CODIGO.md` § 6.

## Como manter

- Ao **gerar** um protótipo, registre a linha com status **rascunho** e a fidelidade lida do N3 (linha `Fidelidade ao protótipo` na `## Superfície`).
- Ao **entregar** um protótipo para fora do repositório — download, anexo, pen drive —, gere antes a versão autocontida: `node scripts/proto-standalone.mjs <protótipo.html> <saída.html>`. Os arquivos daqui referenciam `../../_biblioteca-ds/ds.css`, que é o certo dentro do repositório mas **quebra fora dele**: sem o design system a página abre com todas as telas empilhadas e ícones gigantes, o que parece defeito do protótipo e não é. O script embute o CSS e resolve o `@import` de `tokens.css` — sem isso o arquivo sai com a estrutura certa e nenhuma cor.
- Na **aprovação**, troque o status para **aprovado** e preencha **quem** e **quando**. Só então a tela é **contrato** para a codificação.
- A implementação de telas **obrigatória** exige a **checklist de fidelidade** — `node scripts/fidelity-checklist.mjs <pasta-do-protótipo> <N3.md>` — com **todos os estados cobertos** (✅, ou ⚠️ com desvio aprovado; nenhum ❌).
- **Reforço opcional (CI, onde há runtime):** regressão visual `node scripts/proto-visual-diff.mjs <protótipo> <tela-implementada>` — roda no **repositório de código** (Playwright + app), não aqui. Ver o cabeçalho do script.

## Legenda

- **Fidelidade** — `obrigatória`: a implementação reproduz o protótipo; `referência`: guia a intenção.
- **Status** — `rascunho`: em elaboração; `aprovado`: travado como contrato (registrar quem/quando).
