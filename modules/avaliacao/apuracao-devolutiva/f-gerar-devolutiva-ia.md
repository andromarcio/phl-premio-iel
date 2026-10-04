<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-04
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: [AVL-APU-05]
origem:
  tipo: issue
  chave: HU-031_Consolidar_Feedback
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

# Gerar Devolutiva com IA
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-04`

## Descrição
Permite ao administrador gerar, com apoio de Inteligência Artificial, uma sugestão de devolutiva a partir dos pareceres dos avaliadores finalizados, entregue ao editor para revisão humana.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-031_Consolidar_Feedback`](../../../hus/HU-031_Consolidar_Feedback.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: o Editor de Devolutiva (rota `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`); acionada pela ação "Gerar com IA" ⚠️ *(em HU-027 a ação consta como placeholder em desenvolvimento; especificada conforme HU-031)*

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A devolutiva gerada por IA é sempre submetida à revisão humana antes de ser liberada ao participante → ver Revisar Devolutiva (AVL-APU-05).
2. A sugestão gerada por IA é uma proposta e não fica gravada automaticamente: ela retorna ao editor para o administrador revisar e editar.
3. A geração usa apenas os pareceres dos avaliadores com avaliação finalizada.
4. A sugestão é produzida em português do Brasil, em tom impessoal como voz única da banca, sem citar nomes de avaliadores nem notas, e estruturada em três blocos: Pontos fortes, Pontos a desenvolver e Orientação final da banca.
5. A sugestão retorna marcada como gerada com apoio de IA, e essa marcação acompanha a devolutiva se ela for liberada.

---

## Cenários

```gherkin
Feature: Gerar Devolutiva com IA

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Gerar a sugestão de devolutiva
    Given que os avaliadores da inscrição na etapa finalizaram suas avaliações
    When aciono a geração da devolutiva com IA
    Then o sistema devolve ao editor uma sugestão marcada como gerada com apoio de IA, sem liberá-la ao participante

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Substituir texto existente no editor
    Given que já há texto no editor da devolutiva
    When aciono a geração com IA e confirmo a substituição
    Then o sistema substitui o texto do editor pela nova sugestão marcada como gerada por IA

  Scenario: Sugestão segue para revisão humana
    Given que recebi uma sugestão gerada por IA
    When encerro a geração sem revisar
    Then o sistema mantém a sugestão apenas no editor, pendente de revisão, sem liberar a devolutiva ao participante

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de geração
    Given que meu perfil não tem permissão para gerar a devolutiva
    When tento gerar a sugestão com IA
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Sugestão de devolutiva | gerada pela IA | texto longo | não | proposta editável, não gravada automaticamente |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Gerado com apoio de IA | Sim | Ao devolver a sugestão ao editor |

---

## Comportamento de tela

### Onde fica
No Editor de Devolutiva em `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`, a ação "Gerar com IA" preenche o texto do editor com a sugestão; quando já há conteúdo, uma confirmação precede a substituição. A sugestão fica disponível para revisão antes de qualquer liberação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de gerar desabilitada com indicador enquanto a sugestão é produzida |
| Erro de validação | Não se aplica (a geração parte dos pareceres finalizados) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Preenche o editor com a sugestão marcada como gerada por IA |
| Empty state | Sem pareceres finalizados, a geração fica indisponível |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A geração devolve ao editor uma sugestão marcada como gerada por IA, sem liberá-la ao participante | cenário "Gerar a sugestão de devolutiva" |
| SC-02 | A sugestão gerada por IA só chega ao participante após passar pela revisão humana | cenário "Sugestão segue para revisão humana" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Gerar com IA | SE | 2 | 3 | Simples | 4 | 2026-02-28 |

### Memória de cálculo

- **Gerar com IA** — ALR (2): Premiação · Avaliação de Inscrição. DER (3): Texto consolidação · Ação · Mensagem.

```json
{"pe": "Gerar com IA",
 "alr": ["Premiação", "Avaliação de Inscrição"],
 "der": ["Texto consolidação", "Ação", "Mensagem"]}
```

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-031 (geração assistida por IA) |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
