<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-04
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [INS-PAR-02]
origem:
  tipo: issue
  chave: HU-015_Inscricao_Participante
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

# Reenviar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-04`

## Descrição
Permite ao participante reenviar para validação uma inscrição que teve ajustes solicitados, depois de corrigidos os itens apontados pela análise regional.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: `/inscricao/termos/:inscricaoId` (Termos e Finalização) de uma inscrição em ajuste; dispara o reenvio para validação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O reenvio aplica-se apenas a inscrições no estado aguardando ajuste, solicitado pela validação regional.
2. O reenvio só é concluído depois de corrigidos os itens de ajuste apontados na inscrição.
3. O reenvio faz a inscrição transitar de aguardando ajuste para ajustes concluídos, devolvendo-a à validação regional.
4. O número de protocolo da inscrição é mantido no reenvio, sem gerar um novo.

---

## Cenários

```gherkin
Feature: Reenviar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Reenviar inscrição com ajustes corrigidos
    Given que a inscrição está aguardando ajuste e os itens apontados foram corrigidos
    When aciono o reenvio da inscrição
    Then o sistema devolve a inscrição à validação no estado ajustes concluídos
    And o número de protocolo é mantido

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Itens de ajuste ainda pendentes
    Given que a inscrição está aguardando ajuste com itens apontados ainda pendentes
    When aciono o reenvio
    Then o sistema não reenvia a inscrição

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inscrição sem ajuste solicitado
    Given que a inscrição não está no estado aguardando ajuste
    When tento reenviá-la para validação
    Then o sistema não executa o reenvio
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Status | — | somente leitura | lista (Aguardando ajuste, Ajustes concluídos) | — | passa a Ajustes concluídos no reenvio |
| Número de protocolo | — | somente leitura | texto | — | mantido do envio original |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status | Ajustes concluídos | No reenvio da inscrição |

---

## Comportamento de tela

### Onde fica
Ação de reenvio disponível na inscrição em ajuste, a partir da tela de termos e finalização, depois de o participante corrigir os itens apontados no formulário.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de reenviar desabilitada com indicador enquanto submete |
| Erro de validação | Indica os itens de ajuste ainda pendentes |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Devolve a inscrição à validação e confirma o reenvio |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição em ajuste, com itens corrigidos, é reenviada e volta à validação | cenário "Reenviar inscrição com ajustes corrigidos" |
| SC-02 | O reenvio mantém o número de protocolo original | Regra de negócio 4 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Realizar Ajuste na Inscrição | — | — | — | — | 0 | 2026-02-28 |
| Reenviar Inscrição | EE | 2 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Realizar Ajuste na Inscrição** — ALR (0): —. DER (0): —.
- **Reenviar Inscrição** — ALR (2): Premiação · Inscrição. DER (4): ID Inscrição · Termo de Aceite · Ação · Mensagem.

```json
{"pe": "Reenviar Inscrição",
 "alr": ["Premiação", "Inscrição"],
 "der": ["ID Inscrição", "Termo de Aceite", "Ação", "Mensagem"]}
```

**Total: 3 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
