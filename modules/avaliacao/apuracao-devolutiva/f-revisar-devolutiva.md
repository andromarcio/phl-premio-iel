<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-05
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: []
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

# Revisar Devolutiva
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-05`

## Descrição
Permite ao administrador revisar e editar a devolutiva, tenha ela sido gerada por IA ou escrita à mão, e liberá-la ao participante respeitada a data de liberação da etapa.

No Editor de Devolutiva, aberto a partir da inscrição na etapa na lista de avaliações, o administrador ajusta o texto, confere na pré-visualização como o participante o verá e confirma a liberação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-031_Consolidar_Feedback`](../../../hus/HU-031_Consolidar_Feedback.docx) | Criação | — revisão humana e publicação da consolidação da HU: editar o texto dentro do mínimo e do máximo de 6.000 caracteres, pré-visualizar, liberar com confirmação respeitada a data de liberação da etapa e manter a marca de I.A. na publicação (a HU não numera critérios de aceite) |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId` (Editor de Devolutiva)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A devolutiva só é liberada ao participante após a revisão de uma pessoa — a sugestão gerada por IA nunca chega ao participante sem essa revisão.
2. A liberação da devolutiva respeita a data de liberação configurada na etapa.
3. A devolutiva liberada carrega a marcação de geração por IA quando a sugestão da IA foi aproveitada no texto.
4. A revisão exige um texto com no mínimo 100 caracteres não-brancos e no máximo 6.000 caracteres. ⚠️ *(limites herdados do feedback consolidado — mesmo registro; a confirmar a fronteira consolidação × devolutiva)*
5. A identidade de quem revisou e a dos avaliadores não é exposta ao participante, e as notas individuais também não.

---

## Cenários

```gherkin
Feature: Revisar Devolutiva

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Revisar e liberar a devolutiva
    Given que há uma devolutiva escrita para a inscrição na etapa
    When reviso o texto e confirmo a liberação
    Then o sistema libera a devolutiva ao participante conforme a data de liberação da etapa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Liberar antes da data de liberação da etapa
    Given que a data de liberação da etapa ainda não chegou
    When reviso e confirmo a devolutiva
    Then o sistema registra a devolutiva e só a torna visível ao participante a partir da data de liberação

  Scenario: Revisar devolutiva gerada por IA
    Given que a devolutiva foi gerada com apoio de IA
    When ajusto o texto e confirmo a liberação
    Then o sistema libera a devolutiva ao participante com a marcação de geração por IA

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Texto abaixo do mínimo
    Given que estou revisando a devolutiva
    When reduzo o texto a menos de 100 caracteres e tento liberar
    Then o sistema não libera a devolutiva enquanto o texto não atingir o mínimo de 100 caracteres

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de revisão
    Given que meu perfil não tem permissão para revisar a devolutiva
    When tento liberar a devolutiva
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Devolutiva | Apuração por Etapa | entrada do usuário | editável | texto longo | sim | mínimo de 100 caracteres não-brancos; máximo de 6.000 caracteres |
| Gerado com apoio de IA | Apuração por Etapa | entrada do usuário | somente leitura | booleano | não | marcação preservada quando a sugestão da IA é aproveitada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Liberada por | Autor da revisão | Ao liberar a devolutiva |
| Liberada em | Data e hora da liberação | Ao liberar a devolutiva |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Etapa | lê | Fornece a data de liberação configurada, que decide quando a devolutiva fica visível ao participante (regra 2) |
| Inscrição | lê | Identifica a inscrição a quem a devolutiva pertence |
| Avaliação de Inscrição | lê | Fornece os pareceres dos avaliadores consultados na revisão, sem expor ao participante a identidade nem as notas (regra 5) |

---

## Comportamento de tela

### Onde fica
No Editor de Devolutiva em `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`: edição do texto com pré-visualização de como o participante verá, o registro da última liberação com autor e data, e a confirmação antes de liberar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de liberar desabilitada com indicador enquanto grava |
| Erro de validação | Destaca o texto quando abaixo de 100 caracteres |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta a devolutiva como liberada |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A devolutiva só chega ao participante após a revisão humana e conforme a data de liberação da etapa | cenários "Revisar e liberar a devolutiva" e "Liberar antes da data de liberação da etapa" |
| SC-02 | A devolutiva liberada mantém a marcação de geração por IA quando a sugestão foi aproveitada | cenário "Revisar devolutiva gerada por IA" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Revisar Devolutiva | principal | EE | 3 | 6 | Alta | 6 | 2026-09-01 |

### Memória de cálculo

**Revisar Devolutiva** — EE · ALR 3 · DER 6 · Alta · 6 PF

```json
{"pe": "Revisar Devolutiva",
 "alr": ["Avaliação de Inscrição", "Inscrição", "Premiação"],
 "der": ["Devolutiva", "Gerado com apoio de IA", "Liberada por", "Liberada em", "Mensagem", "Ação"]}
```

Por que cada ALR:
1. `Avaliação de Inscrição` — grava a devolutiva revisada, a marcação de IA e a liberação; lê os pareceres dos avaliadores
2. `Inscrição` — a quem a devolutiva pertence
3. `Premiação` — a data de liberação configurada na etapa (regra 2)

Classificação EE. Formas de lógica: 1 (mínimo de 100 e máximo de 6.000 caracteres), 5 (a liberação respeita a data configurada na etapa), 6 (grava o texto revisado e a liberação), 7, 12. Intenção primária: manter ALI.

Dos 6 DER, 2 são de entrada (Devolutiva e Gerado com apoio de IA) e 2 de saída (Liberada por e Liberada em), mais Mensagem e Ação.

Fora da contagem: a identidade dos avaliadores e as notas individuais não cruzam a fronteira (regra 5) — são lidas para compor o texto e não são apresentadas.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa do que a feature realiza da HU na `## Origem` (a HU não numera critérios de aceite), coluna Entidade e as sete colunas do padrão em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo com o cabeçalho do processo elementar e a lista dos ALR no formato do engine. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **6 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-031 (revisão humana antes da liberação) |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
