<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-MOD-05
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-005_Cadastrar_Modalidades
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

# Ativar/Inativar Modalidade
> **Nível 3** - Feature Set: Modalidades — Major Feature Set: Configuração da Premiação - `CFG-MOD-05`

## Descrição
Permite ao administrador alternar a situação ativa/inativa de uma modalidade (exclusão lógica) sem afetar os tipos de participante vinculados, controlando a oferta da forma de participação nos fluxos de inscrição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-005_Cadastrar_Modalidades`](../../../hus/HU-005_Cadastrar_Modalidades.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Catálogo de Modalidades (`/modalidades`), a partir do botão de situação na linha da modalidade, com confirmação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A inativação é lógica: a modalidade não é removida, apenas passa à situação inativa.
2. A inativação de uma modalidade não altera a situação dos tipos de participante a ela vinculados.
3. Uma modalidade inativa não é ofertada nos fluxos de inscrição pública.

---

## Cenários

```gherkin
Feature: Ativar/Inativar Modalidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Inativar modalidade
    Given que identifico uma modalidade ativa
    When clico em "Desativar" e confirmo
    Then o sistema passa a modalidade para a situação inativa

  Scenario: Reativar modalidade
    Given que identifico uma modalidade inativa
    When clico em "Ativar" e confirmo
    Then o sistema passa a modalidade para a situação ativa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inativação não cascateia para os tipos de participante
    Given que a modalidade possui tipos de participante vinculados ativos
    When inativo a modalidade
    Then os tipos de participante vinculados permanecem com a situação que tinham

  Scenario: Modalidade inativa fora da inscrição pública
    Given que a modalidade está inativa
    When um participante acessa o fluxo público de inscrição
    Then a modalidade inativa não é apresentada como opção

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para inativar
    Given que meu perfil não tem permissão para inativar modalidades
    When tento inativar uma modalidade
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Modalidade | Modalidade | somente leitura | texto | — | modalidade sobre a qual a ação é aplicada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Alterna entre Ativo e Inativo | Ao confirmar a ação de situação |

---

## Comportamento de tela

### Onde fica
Ação disparada da linha da modalidade no Catálogo de Modalidades (`/modalidades`): botão contextual que mostra "Desativar" quando ativa e "Ativar" quando inativa, seguido de confirmação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação exibida na linha da modalidade |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Ao confirmar, a modalidade alterna corretamente entre ativa e inativa | cenários "Inativar modalidade" / "Reativar modalidade" |
| SC-02 | A inativação de uma modalidade não cascateia para os tipos de participante vinculados | Critério de aceite 3 (HU-005) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Ativar/Inativar Modalidade | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Ativar/Inativar Modalidade** — ALR (1): Modalidade. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Ativar/Inativar Modalidade",
 "alr": ["Modalidade"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
