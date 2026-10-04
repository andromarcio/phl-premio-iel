<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-04
feature_set: CFG-VIN
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade--categoria-vinculo
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-011_Vincular_Categoria_Modalidade_TipoParticipante
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

# Vincular Modalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-04`

## Descrição
Permite ao administrador associar uma modalidade a uma categoria já vinculada à edição, ou criar uma nova modalidade e vinculá-la, formando o segundo nível da estrutura do prêmio.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*), ação de vincular no nó de uma categoria, que abre o Diálogo de Vínculo com o catálogo de modalidades e a opção de criar uma nova.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Uma modalidade só pode estar vinculada uma vez à mesma categoria da edição; a mesma modalidade pode servir a categorias diferentes.
2. Vincular uma modalidade exige uma categoria já vinculada à edição como nó de origem.
3. Ao criar e vincular, a modalidade passa a existir no catálogo e fica vinculada à categoria na mesma operação.
4. O vínculo entre modalidade e categoria guarda dados próprios daquele contexto: link do regulamento, início e fim das inscrições e ordem.

---

## Cenários

```gherkin
Feature: Vincular Modalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Vincular modalidade existente a uma categoria da edição
    Given que uma categoria já está vinculada à edição
    When seleciono uma modalidade disponível no catálogo e confirmo
    Then o sistema cria o vínculo e a modalidade passa a integrar a categoria na edição

  Scenario: Criar e vincular uma nova modalidade num único passo
    Given que estou vinculando uma modalidade à categoria da edição
    When informo o nome de uma nova modalidade e confirmo criar e vincular
    Then o sistema registra a modalidade no catálogo e a vincula à categoria na mesma operação

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Modalidade já vinculada à categoria
    Given que a modalidade já está vinculada à categoria na edição
    When tento vinculá-la novamente à mesma categoria
    Then o sistema não cria um novo vínculo e mantém apenas o existente

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para vincular
    Given que meu perfil não tem permissão para vincular modalidades
    When tento vincular uma modalidade à categoria
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Categoria da edição | seleção → Categoria vinculada | somente leitura | seleção | sim | categoria já vinculada que recebe a modalidade |
| Modalidade | seleção → Modalidade | editável | seleção (catálogo) | sim | modalidade ainda não vinculada à categoria |
| Nome (nova modalidade) | entrada do usuário | editável | texto | condicional | obrigatório ao criar e vincular; máximo de 200 caracteres |
| Link do regulamento | entrada do usuário | editável | texto (URL) | não | → ver FIELD-DICTIONARY: URL |
| Início das inscrições | entrada do usuário | editável | data e hora | não | data em que as inscrições da modalidade abrem |
| Fim das inscrições | entrada do usuário | editável | data e hora | não | posterior ao início das inscrições |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Próxima posição na categoria | Ao criar o vínculo |
| Situação do vínculo | Ativo | Ao vincular a modalidade à categoria |

---

## Comportamento de tela

### Onde fica
Ação disparada do nó de uma categoria na Árvore de Configuração do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*): abre o Diálogo de Vínculo com o catálogo de modalidades disponíveis e a opção de criar e vincular uma nova.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão de confirmação desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." ao criar e vincular sem nome |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Fecha o diálogo, recarrega a árvore e mostra o novo nó da modalidade |
| Empty state | Catálogo sem modalidades disponíveis: oferece criar e vincular uma nova |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma modalidade é vinculada a uma categoria já vinculada e passa a integrar a estrutura | cenário "Vincular modalidade existente a uma categoria da edição" |
| SC-02 | Criar e vincular registra a modalidade e cria o vínculo numa única operação | Critério de aceite 2 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Copiar Modalidade | EE | 2 | 3 | Simples | 3 | 2026-02-28 |
| Criar e Vincular Modalidade | EE | 2 | 7 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

- **Copiar Modalidade** — ALR (2): Modalidade · Premiação. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Copiar Modalidade",
 "alr": ["Modalidade", "Premiação"],
 "der": ["ID", "Ação", "Mensagem"]}
```
- **Criar e Vincular Modalidade** — ALR (2): Modalidade · Premiação. DER (7): Nome · Descrição · Link do Regulamento · Data Início Período Inscrição · Data Fim Período Inscrição · Ação · Mensagem.

```json
{"pe": "Criar e Vincular Modalidade",
 "alr": ["Modalidade", "Premiação"],
 "der": ["Nome", "Descrição", "Link do Regulamento", "Data Início Período Inscrição", "Data Fim Período Inscrição", "Ação", "Mensagem"]}
```

**Total: 7 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
