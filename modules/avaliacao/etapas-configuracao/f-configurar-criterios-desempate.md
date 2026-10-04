<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-06
feature_set: AVL-ETA
dominio: AVL
entidade: Critério de Desempate
data_model_ref: data-models/avaliacao.md#critério-de-desempate
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-032_Configurar_Criterios_de_Desempate
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

# Configurar Critérios de Desempate
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-06`

## Descrição
Permite ao Administrador Nacional definir, por tipo de participante, a lista ordenada de questões que o sistema aplica para quebrar empates de média no ranking, seguindo o modelo lexicográfico.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-032_Configurar_Criterios_de_Desempate`](../../../hus/HU-032_Configurar_Criterios_de_Desempate.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/premiacoes/:id/avaliacao-etapas#criterios` (bloco Critérios de Desempate na aba Avaliação & Etapas)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Os critérios de desempate são configurados por premiação, com uma lista ordenada e independente por tipo de participante.
2. Cada critério é uma questão do questionário de avaliação do respectivo tipo de participante.
3. A ordem dos critérios define a aplicação lexicográfica: o primeiro critério decide o desempate; persistindo o empate, aplica-se o próximo, até esgotar a lista.
4. Uma mesma questão aparece no máximo uma vez como critério ativo de uma premiação.
5. Cada posição de ordem é única dentro da lista de critérios ativos de uma premiação.
6. Salvar a configuração substitui integralmente a lista de critérios anterior da premiação: os critérios ausentes da nova lista deixam de vigorar.
7. A configuração de critérios não pode ser alterada enquanto houver etapa da premiação com prazo final já encerrado e situação ainda Aberta (janela de fechamento em curso); etapas já Fechadas não impõem esse impedimento.
8. Com zero critérios configurados para um tipo de participante, os empates de média desse tipo passam a ser resolvidos manualmente pelo Administrador Nacional no fechamento da etapa. ⚠️ *(a resolução manual é especificada em feature própria fora deste lote — HU "Fechar Etapa de Avaliação" não disponível no acervo)*
9. Duas inscrições só competem entre si — e portanto só podem empatar — quando compartilham o mesmo tipo de participante, modalidade e categoria e o mesmo enquadramento.

---

## Cenários

```gherkin
Feature: Configurar Critérios de Desempate

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Selecionar e ordenar critérios de um tipo de participante
    Given que o tipo de participante tem questões de avaliação disponíveis
    When seleciono questões como critério, defino a ordem de aplicação e salvo
    Then o sistema grava a lista ordenada de critérios e exibe "Registro salvo com sucesso."

  Scenario: Substituir integralmente a configuração ao salvar
    Given que a premiação já tem critérios configurados
    When removo um critério da lista e salvo
    Then o sistema passa a vigorar apenas com os critérios enviados e desativa o critério removido

  # ── Estados especiais ──────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_CRITERIOS_BLOQUEADO
  Scenario: Configuração bloqueada durante a janela de fechamento
    Given que existe etapa com prazo encerrado e situação ainda Aberta
    When acesso a configuração de critérios de desempate
    Then o sistema impede a alteração e exibe "Não é possível alterar critérios de desempate: existe etapa com prazo encerrado em fase de fechamento."

  # ← MESSAGE-DICTIONARY: AVL_CRITERIOS_SEM_TIPO
  Scenario: Premiação sem tipos de participante vinculados
    Given que a premiação ainda não tem tipos de participante vinculados
    When acesso a configuração de critérios de desempate
    Then o sistema exibe "Esta premiação ainda não tem tipos de participante vinculados. Adicione modalidades e tipos de participante antes de configurar critérios de desempate."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de configuração
    Given que meu perfil não tem permissão para configurar critérios de desempate
    When tento salvar a configuração
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Tipo de participante | derivado (árvore Categoria → Modalidade → Tipo de Participante) | somente leitura | referência → Tipo de Participante | — | um bloco de configuração por tipo de participante da premiação |
| Questão de critério | seleção → Questão de Avaliação do tipo | editável | seleção múltipla | não | cada questão no máximo uma vez por premiação |
| Ordem de aplicação | entrada do usuário (reordenação) | editável | número inteiro | não | posição única na lista de critérios ativos da premiação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Critérios desativados | Critérios ausentes da nova lista | Ao salvar a configuração (substituição integral) |

---

## Comportamento de tela

### Onde fica
Bloco "Critérios de Desempate" na aba "Avaliação & Etapas" (`/premiacoes/:id/avaliacao-etapas#criterios`), abaixo da listagem de etapas: um cartão por tipo de participante, com as questões disponíveis à esquerda e a lista ordenada de critérios à direita, reordenável por arraste.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar critérios" desabilitado com indicador enquanto grava |
| Erro de validação | Não se aplica (seleção e ordem são opcionais por tipo) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a nova lista de critérios |
| Empty state | Sem tipos de participante: mensagem orientando a vincular modalidades e tipos; com zero critérios: aviso de que os empates serão resolvidos manualmente |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A lista ordenada de critérios por tipo de participante é salva e passa a vigorar | cenário "Selecionar e ordenar critérios de um tipo de participante" |
| SC-02 | Salvar substitui integralmente a configuração, desativando os critérios ausentes | cenário "Substituir integralmente a configuração ao salvar" |
| SC-03 | A alteração é impedida enquanto há etapa em janela de fechamento | cenário "Configuração bloqueada durante a janela de fechamento" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Configurar Critérios de Desempate | EE | — | 11 | Simples | 3 | 2026-02-28 |
| Consultar Critérios de Desempate | CE | — | 10 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Configurar Critérios de Desempate** — ALR (0): Premiação · Avaliação de Inscrição · Tipo de Participante · Inscrição. DER (11): Tipo de participante · Quetões disponíveis · Questão · Descrição questão · Tipo · Peso · Ordem · Qtd Critérios configurados · Qtd critérios selecionados · Ação · Mensagem.
- **Consultar Critérios de Desempate** — ALR (0): Premiação · Avaliação de Inscrição · Tipo de Participante · Inscrição. DER (10): Tipo de participante · Quetões disponíveis · Questão · Descrição questão · Tipo · Peso · Ordem · Qtd Critérios configurados · Qtd critérios selecionados · Ação.

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-032 |

---

*Feature Set: Etapas e Configuração da Avaliação · Major Feature Set: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
