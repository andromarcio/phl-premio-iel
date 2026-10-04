<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-07
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
data_model_ref: data-models/avaliacao.md#alocacao-de-avaliadores
endpoints: []
error_codes: []
depende_de: [AVL-ALO-01]
origem:
  tipo: issue
  chave: PDTIC25093-65
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Exportar Relatório de Alocação
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-07`

## Descrição
Entrega em planilha o retrato da alocação de uma etapa — quantos projetos cada avaliador recebeu e, nas etapas regionais, como a alocação se distribui por estado — para conferência e acompanhamento fora do sistema.

Na tela Alocação por Grupo, com a etapa selecionada, o administrador aciona "Relatório de alocação (XLSX)" e recebe a planilha para download.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-65`](../../../analise-impacto/AIM-PDTIC25093-65.md) | Criação | — item 1 do card: o relatório da alocação em planilha, por avaliador e, quando a etapa é regional, por estado |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), botão "Relatório de alocação (XLSX)"

**Fidelidade ao protótipo**: n/a *(o protótipo de Alocação não representa a exportação — conferido em 2026-08-28)*

---

</div>

## Regras de negócio

1. O relatório abrange uma etapa por vez.
2. O relatório considera as mesmas inscrições elegíveis à alocação da etapa consultada. → ver `AVL-ALO-04` (Alocar Avaliador à Inscrição)
3. O relatório sempre traz a distribuição por avaliador.
4. A distribuição por estado só integra o relatório quando a etapa é operada também pelo Administrador Regional.
5. O Administrador Regional exporta apenas as alocações dentro do seu escopo — tanto pela unidade federativa da inscrição quanto pela unidade de atuação do avaliador.
6. A inscrição sem unidade federativa definida é apresentada na distribuição por estado como **Nacional**.

---

## Cenários

```gherkin
Feature: Exportar Relatório de Alocação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar a alocação de uma etapa regional
    Given que estou na alocação por grupo de uma etapa operada pelo Administrador Regional
    When aciono "Relatório de alocação (XLSX)"
    Then o sistema entrega uma planilha com a distribuição por estado e a distribuição por avaliador

  Scenario: Exportar a alocação de uma etapa nacional
    Given que estou na alocação por grupo de uma etapa operada apenas pelo Administrador Nacional
    When aciono "Relatório de alocação (XLSX)"
    Then o sistema entrega uma planilha apenas com a distribuição por avaliador

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Etapa sem nenhuma alocação
    Given que a etapa ainda não tem avaliadores designados
    When exporto o relatório de alocação
    Then a planilha é entregue sem linhas de avaliador

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Exportação por administrador regional
    Given que estou autenticado como Administrador Regional vinculado à Bahia
    When exporto o relatório de alocação da etapa
    Then a planilha traz apenas as alocações dentro do meu escopo
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Etapa | Etapa | entrada do usuário | somente leitura | seleção → Etapa | sim | a etapa da premiação em consulta na alocação por grupo |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Distribuição por avaliador | aba sempre presente, uma linha por avaliador: Avaliador, Login, Grupo, Alocadas, A iniciar, Em andamento e Finalizadas | Ao gerar a planilha |
| Distribuição por estado | aba presente apenas nas etapas operadas também pelo Administrador Regional, uma linha por estado: Inscrições, Com avaliador, Sem avaliador, A iniciar, Em andamento, Finalizadas e Avaliadores atuantes | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório de alocação | Ao entregar a planilha |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Alocação de Avaliadores | lê | Quem está alocado em cada grupo da etapa (regra 3) |
| Avaliação de Inscrição | lê | A situação de cada avaliação — a iniciar, em andamento ou finalizada — nas duas abas (regras 3 e 4) |
| Inscrição | lê | As inscrições elegíveis à alocação da etapa e a unidade federativa de cada uma (regras 2, 5 e 6) |
| Perfil de Acesso à Etapa | lê | Os perfis que operam a etapa decidem se a distribuição por estado integra o relatório (regra 4) |
| Usuário | lê | O avaliador, o seu login e as unidades de atuação que recortam o escopo do Administrador Regional (regra 5) |
| Unidade Federativa | lê | O estado de cada linha da distribuição por estado (regras 5 e 6) |
| Categoria | lê | Compõe o grupo da coluna *Grupo* da aba por avaliador |
| Modalidade | lê | Compõe o grupo da coluna *Grupo* da aba por avaliador |
| Tipo de Participante | lê | Compõe o grupo da coluna *Grupo* da aba por avaliador |

---

## Comportamento de tela

### Onde fica
Botão "Relatório de alocação (XLSX)" no cabeçalho da Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), habilitado depois que uma etapa está selecionada. A planilha é baixada pelo navegador.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão desabilitado com indicador enquanto a planilha é gerada |
| Erro de validação | Botão permanece desabilitado enquanto não houver etapa selecionada |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | O download da planilha começa |
| Empty state | Etapa sem alocações gera planilha sem linhas de avaliador |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A planilha reproduz a carga de cada avaliador na etapa consultada | cenário "Exportar a alocação de uma etapa regional" |
| SC-02 | A distribuição por estado só aparece nas etapas regionais | cenário "Exportar a alocação de uma etapa nacional" |
| SC-03 | A exportação respeita o escopo do Administrador Regional | cenário "Exportação por administrador regional" |

---

## Métricas de tamanho

> Contagem realizada em 2026-10-02 sobre este N3, para um processo elementar que **não existe no baseline APF** de 2026-02-28 — a capacidade foi pedida em `PDTIC25093-65`, de 2026-08-26, seis meses depois de o baseline ser levantado. A premissa anterior desta seção dizia "sem processo elementar correspondente", o que descrevia a ausência na planilha e não a sua causa. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Exportar Relatório de Alocação | principal | SE | 7 | 16 | Alta | 7 | 2026-10-04 |

### Memória de cálculo

**Exportar Relatório de Alocação** — SE · ALR 7 · DER 16 · Alta · 7 PF

```json
{"pe": "Exportar Relatório de Alocação",
 "alr": ["Alocação Avaliadores", "Avaliação de Inscrição", "Inscrição", "Usuário", "Categoria", "Modalidade", "Tipo de Participante"],
 "der": ["Etapa", "Estado", "Inscrições", "Com avaliador", "Sem avaliador", "A iniciar", "Em andamento", "Finalizadas", "Avaliadores atuantes", "Avaliador", "Login", "Grupo", "Alocadas", "Nome do arquivo", "Mensagem", "Ação"],
 "nao_contados": "Premiação — a memória enumera oito arquivos e a contagem registra ALR 7"}
```

Formas de lógica: 3 (a distribuição por estado só integra o relatório nas etapas operadas também pelo Administrador Regional, regra 4), 4, 7, 8, 9 (a carga de cada avaliador e o total por estado são contagens), 11, 12. Intenção primária: apresentar, com dado derivado.

Por que cada ALR:
1. `Alocação Avaliadores` — quem está alocado em cada grupo da etapa
2. `Avaliação de Inscrição` — a situação de cada avaliação: a iniciar, em andamento, finalizada
3. `Inscrição` — as inscrições elegíveis à alocação (regra 2)
4. `Usuário` — o avaliador, o seu login e o recorte por UF do Regional (regra 5)
5. `Categoria` — o grupo que nomeia cada linha da aba por avaliador
6. `Modalidade` — o grupo que nomeia cada linha da aba por avaliador
7. `Tipo de Participante` — o grupo que nomeia cada linha da aba por avaliador

A memória anterior enumerava também `Premiação` — a Etapa e os perfis que a operam (regra 4).

⚠️ A revisão de 2026-10-04 levou o ALR de 4 a 7: a coluna **Grupo** da aba por avaliador referencia os três arquivos do grupo competitivo, o que a enumeração anterior não via.

⚠️ A memória enumera oito arquivos — os sete acima e `Premiação` — e a tabela conta ALR 7; o Changelog de 2026-10-04 diz que entraram quatro arquivos sobre os quatro de 2026-10-02, o que também daria oito. Ficou o número da tabela, e `Premiação` foi para `nao_contados` só para a lista fechar com ele — a enumeração de 2026-10-02 não está registrada para dizer qual arquivo sobra. Com ALR 4 ou mais e DER 16 a SE é Alta nos dois casos, e o PF não se move; a divergência vai à equipe de métricas junto com a validação desta contagem.

Como os 16 DER se distribuem: entrada (1) — Etapa; saída da aba por estado (8) — Estado, Inscrições, Com avaliador, Sem avaliador, A iniciar, Em andamento, Finalizadas e Avaliadores atuantes; saída da aba por avaliador (4) — Avaliador, Login, Grupo e Alocadas, porque as três situações dessa aba (A iniciar, Em andamento e Finalizadas) repetem as da aba por estado e contam uma vez; padrão (3) — Nome do arquivo, Mensagem e Ação.

Fora da contagem: a presença ou ausência da aba por estado é forma de lógica de processamento (regra 4), não DER; a inscrição sem UF apresentada como Nacional (regra 6) é valor de um DER existente; a etapa sem alocação devolve a mesma planilha, sem linhas de avaliador, e não um processo elementar distinto.

**Total: 7 PF** (1 processo elementar). A revisão de 2026-10-04 contra o resumo de entrega da Sprint 6 levou o ALR de 4 a 7 e o DER de 9 a 16 — ALR 4 ou mais com DER entre 6 e 19 cai na mesma célula da tabela de SE, de modo que a complexidade segue Alta e o PF não se move.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza do ticket; coluna Entidade em `## Campos`, com o Preenchimento da Etapa corrigido; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com a anotação retirada da lista de ALR para a prosa, as três situações nomeadas e o porquê de cada ALR em prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Colunas conciliadas · memória corrigida | **Correção** da enumeração a partir do resumo de entrega da Sprint 6, que nomeia as colunas das duas abas. *Antes* a memória supunha três colunas na aba por avaliador e duas na por estado, e não via que a coluna **Grupo** referencia o grupo competitivo. *Agora* ALR 7 (entram Avaliação de Inscrição, Categoria, Modalidade e Tipo de Participante) e DER 16, com as colunas nomeadas uma a uma. A RN6 registra a inscrição sem UF como Nacional. **7 PF inalterados** — mesma célula da tabela de SE |
| 2026-10-02 | Análise de impacto `PDTIC25093-65` (docqui) | Contagem realizada · origem identificada | Processo elementar contado sobre este N3 — **7 PF** (SE, ALR 4, DER 9), com a memória de cálculo. A premissa de "sem PE correspondente" era efeito, não causa: a capacidade foi pedida em `PDTIC25093-65`, de 2026-08-26, depois do baseline de 2026-02-28. ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório de alocação por etapa) — capacidade implementada e até então não especificada |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
