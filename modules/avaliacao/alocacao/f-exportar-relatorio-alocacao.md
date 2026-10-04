<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-07
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
prioridade: P2
mvp: false
data_model_ref: data-models/avaliacao.md#alocacao-de-avaliadores
endpoints: []
error_codes: []
depende_de: [AVL-ALO-01]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Exportar Relatório de Alocação
> **Nível 3** - Feature Set: Alocação — Domínio: Avaliação - `AVL-ALO-07`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Entrega em planilha o retrato da alocação de uma etapa — quantos projetos cada avaliador recebeu e, nas etapas regionais, como a alocação se distribui por estado — para conferência e acompanhamento fora do sistema.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Etapa | seleção → Etapa da premiação | somente leitura | lista de opções | sim | a etapa em consulta na alocação por grupo |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Distribuição por avaliador | aba sempre presente, uma linha por avaliador: Avaliador, Login, Grupo, Alocadas, A iniciar, Em andamento e Finalizadas | Ao gerar a planilha |
| Distribuição por estado | aba presente apenas nas etapas operadas também pelo Administrador Regional, uma linha por estado: Inscrições, Com avaliador, Sem avaliador, A iniciar, Em andamento, Finalizadas e Avaliadores atuantes | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório de alocação | Ao entregar a planilha |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Exportar Relatório de Alocação | SE | 7 | 16 | Alta | 7 | 2026-10-04 |

### Memória de cálculo

**Exportar Relatório de Alocação** — SE. Formas de lógica: 3 (a distribuição por estado só integra o relatório nas etapas operadas também pelo Administrador Regional, regra 4), 4, 7, 8, 9 (a carga de cada avaliador e o total por estado são contagens), 11, 12. Intenção primária: apresentar, com dado derivado.
- **ALR (7)**: Alocação Avaliadores *(quem está alocado em cada grupo da etapa)* · Avaliação de Inscrição *(a situação de cada avaliação: a iniciar, em andamento, finalizada)* · Inscrição *(as inscrições elegíveis à alocação, regra 2)* · Premiação *(a Etapa e os perfis que a operam, regra 4)* · Usuário *(o avaliador, o seu login e o recorte por UF do Regional, regra 5)* · Categoria · Modalidade · Tipo de Participante *(o grupo que nomeia cada linha da aba por avaliador)*. ⚠️ A revisão de 2026-10-04 levou o ALR de 4 a 7: a coluna **Grupo** da aba por avaliador referencia os três arquivos do grupo competitivo, o que a enumeração anterior não via.
- **DER (16)** — entrada (1): Etapa. Saída da aba por estado (8): Estado · Inscrições · Com avaliador · Sem avaliador · A iniciar · Em andamento · Finalizadas · Avaliadores atuantes. Saída da aba por avaliador (4): Avaliador · Login · Grupo · Alocadas *(as três situações repetem as da aba por estado e contam uma vez)*. Padrão (3): Nome do arquivo · Mensagem · Ação.
- **Fora da contagem**: a presença ou ausência da aba por estado é forma de lógica de processamento (regra 4), não DER; a inscrição sem UF apresentada como Nacional (regra 6) é valor de um DER existente; a etapa sem alocação devolve a mesma planilha, sem linhas de avaliador, e não um processo elementar distinto.

**Total: 7 PF** (1 processo elementar). A revisão de 2026-10-04 contra o resumo de entrega da Sprint 6 levou o ALR de 4 a 7 e o DER de 9 a 16 — ALR 4 ou mais com DER entre 6 e 19 cai na mesma célula da tabela de SE, de modo que a complexidade segue Alta e o PF não se move.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Colunas conciliadas · memória corrigida | **Correção** da enumeração a partir do resumo de entrega da Sprint 6, que nomeia as colunas das duas abas. *Antes* a memória supunha três colunas na aba por avaliador e duas na por estado, e não via que a coluna **Grupo** referencia o grupo competitivo. *Agora* ALR 7 (entram Avaliação de Inscrição, Categoria, Modalidade e Tipo de Participante) e DER 16, com as colunas nomeadas uma a uma. A RN6 registra a inscrição sem UF como Nacional. **7 PF inalterados** — mesma célula da tabela de SE |
| 2026-10-02 | Análise de impacto `PDTIC25093-65` (docqui) | Contagem realizada · origem identificada | Processo elementar contado sobre este N3 — **7 PF** (SE, ALR 4, DER 9), com a memória de cálculo. A premissa de "sem PE correspondente" era efeito, não causa: a capacidade foi pedida em `PDTIC25093-65`, de 2026-08-26, depois do baseline de 2026-02-28. ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório de alocação por etapa) — capacidade implementada e até então não especificada |

---

*Feature Set: Alocação · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
