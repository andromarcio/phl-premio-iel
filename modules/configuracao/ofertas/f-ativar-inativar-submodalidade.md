<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-11
feature_set: CFG-VIN
dominio: CFG
entidade: Oferta
data_model_ref: data-models/configuracao.md#oferta-tipo--modalidade--categoria
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

# Ativar/Inativar Submodalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-11`

## Descrição
Permite ao administrador alternar a situação ativa/inativa de uma submodalidade (exclusão lógica), controlando se a oferta fica disponível para inscrição sem removê-la da edição.

Na lista de Submodalidades da Oferta (aba "Geral" do nó do tipo de participante), o administrador aciona "Desativar" na linha da submodalidade — ou "Ativar", se ela estiver inativa — e confirma a troca de situação.

> ⚠️ **Colisão de terminologia confirmada no código** (2026-08-28). O que esta feature descreve — o vínculo tipo de participante × modalidade × categoria, com parâmetros de equipe e slug — é a **Oferta** (`TB_TIPO_PART_MOD_CAT`), configurada na aba **Geral** do editor de Tipo de Participante. Na interface implementada, o rótulo **“Sub Modalidades”** designa outra coisa: o **Enquadramento** (`TB_ENQUADRAMENTO`, features `CFG-TIP-10`/`CFG-TIP-11`). Renomear esta feature depende de decisão do PO — ver `global/CONFORMIDADE-CODIGO.md` § 3.2.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — a situação da oferta, vínculo tipo × modalidade × categoria definido na HU (RN1 e RN5); a alternância ativa/inativa não tem critério numerado |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Submodalidades da Oferta (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)*), a partir do botão de situação na linha da submodalidade, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A inativação é lógica: a submodalidade não é removida, apenas passa à situação inativa.
2. Uma submodalidade inativa não é ofertada nos fluxos de inscrição pública.
3. A situação da submodalidade é independente da situação do tipo de participante, da modalidade e da categoria que a compõem.

---

## Cenários

```gherkin
Feature: Ativar/Inativar Submodalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Inativar submodalidade
    Given que identifico uma submodalidade ativa
    When clico em "Desativar" e confirmo
    Then o sistema passa a submodalidade para a situação inativa

  Scenario: Reativar submodalidade
    Given que identifico uma submodalidade inativa
    When clico em "Ativar" e confirmo
    Then o sistema passa a submodalidade para a situação ativa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Submodalidade inativa fora da inscrição pública
    Given que a submodalidade está inativa
    When um participante acessa o fluxo público de inscrição
    Then a submodalidade inativa não é apresentada como opção

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para inativar
    Given que meu perfil não tem permissão para inativar submodalidades
    When tento inativar uma submodalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Submodalidade | Oferta | exibido do cadastro | somente leitura | texto | — | submodalidade sobre a qual a ação é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Alterna entre Ativo e Inativo | Ao confirmar a ação de situação |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha da submodalidade em Submodalidades da Oferta (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)*): botão contextual que mostra "Desativar" quando ativa e "Ativar" quando inativa, seguido de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação exibida na linha da submodalidade |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, a submodalidade alterna corretamente entre ativa e inativa | cenários "Inativar submodalidade" / "Reativar submodalidade" |
| SC-02 | Uma submodalidade inativa não é ofertada na inscrição pública | regra de negócio 2 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Ativar/Inativar Submodalidade | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Ativar/Desativar Submodalidade*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Ativar/Inativar Submodalidade** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Ativar/Inativar Submodalidade",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo Participante` — grava a nova situação da submodalidade (subgrupo do arquivo lógico Tipo de Participante)

⚠️ No documento legado (`hus/LEGADO_PIEL_Configurar_Premio.docx`), *Ativar/Desativar Submodalidade* alterna a situação do enquadramento, que a tela rotula "Sub Modalidades" (ver a nota da Descrição e `global/CONFORMIDADE-CODIGO.md` § 3.2). Ficou o número da planilha; cabe à equipe de métricas dizer se o processo pertence a `CFG-TIP-11` — Ativar/Inativar Enquadramento, hoje sem processo elementar.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), com a nota de colisão de terminologia movida para depois dele; critérios da HU na `## Origem`, coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
