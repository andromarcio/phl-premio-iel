<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-03
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [INS-PAR-05, INS-PAR-06]
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

# Finalizar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-03`

## Descrição
Permite ao participante submeter a inscrição para validação após a checagem dos itens obrigatórios, gerando o número de protocolo que identifica a inscrição enviada.

Na tela de termos e finalização, depois de aceitar os termos obrigatórios, o participante aciona "Finalizar Inscrição"; havendo pendências, vê a lista agrupada em campos, anexos e questões, e, sem pendências, recebe o número de protocolo no resumo da inscrição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — a HU não numera critérios; realiza "Finalizar Inscrição": checagem de campos, anexos e questões obrigatórios com os erros agrupados por tipo, finalização habilitada só com os termos obrigatórios aceitos, protocolo gerado e passagem a Finalizada |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: `/inscricao/termos/:inscricaoId` (Termos e Finalização); dispara a submissão da inscrição para validação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A finalização só é concluída quando todos os campos obrigatórios estão preenchidos, os anexos obrigatórios enviados e as questões obrigatórias respondidas.
2. A finalização só é habilitada depois que todos os termos obrigatórios da premiação foram aceitos.
3. O número de protocolo é gerado no momento da finalização e identifica a inscrição enviada.
4. A finalização faz a inscrição transitar do estado em andamento para finalizada, encaminhando-a à validação regional.
5. Uma inscrição já finalizada não pode ser finalizada novamente enquanto permanecer nesse estado.

---

## Cenários

```gherkin
Feature: Finalizar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Finalizar inscrição completa
    Given que a inscrição tem todos os itens obrigatórios preenchidos e os termos obrigatórios aceitos
    When aciono a finalização da inscrição
    Then o sistema gera o número de protocolo
    And a inscrição passa ao estado finalizada, encaminhada à validação

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Itens obrigatórios pendentes
    Given que a inscrição tem campos, anexos ou questões obrigatórios ainda pendentes
    When aciono a finalização
    Then o sistema não finaliza e exibe "Há itens obrigatórios pendentes. Revise os campos, anexos e questões indicados."
    # ← MESSAGE-DICTIONARY: INS_FINALIZACAO_PENDENCIAS

  Scenario: Termo obrigatório não aceito
    Given que existe um termo obrigatório ainda não aceito
    When tento finalizar a inscrição
    Then o sistema não finaliza a inscrição

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inscrição já finalizada
    Given que a inscrição já foi finalizada
    When aciono novamente a finalização
    Then o sistema mantém a inscrição no estado atual e não gera novo protocolo
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Número de protocolo | Inscrição | calculado | somente leitura | texto | — | gerado na finalização; identifica a inscrição enviada |
| Status | Inscrição | calculado | somente leitura | lista (Rascunho, Em andamento, Finalizada, Em validação, Validada, Rejeitada, Aguardando ajuste, Ajustes concluídos) | — | passa a Finalizada na submissão |
| Data de finalização | Inscrição | calculado | somente leitura | data e hora | — | registrada no momento da finalização |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Número de protocolo | Número gerado pelo sistema | Na finalização da inscrição |
| Status | Finalizada | Na finalização da inscrição |
| Data de finalização | Data e hora da finalização | Na finalização da inscrição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Resposta de Formulário | lê | Conferência dos campos obrigatórios preenchidos (regra 1) |
| Resposta de Questão | lê | Conferência das questões obrigatórias respondidas (regra 1) |
| Documento da Inscrição | lê | Conferência dos anexos obrigatórios enviados (regra 1) |
| Aceite de Termo do Participante | lê | A finalização só é habilitada com todos os termos obrigatórios aceitos (regra 2) |
| Campo do Formulário | lê | Obrigatoriedade de cada campo na configuração da oferta (regra 1) |
| Questão de Avaliação | lê | Obrigatoriedade de cada questão do questionário (regra 1) |
| Configuração de Anexo | lê | Anexos obrigatórios da oferta (regra 1) |
| Termo de Aceite | lê | Quais termos da premiação são obrigatórios (regra 2) |

---

## Comportamento de tela

### Onde fica
Tela de termos e finalização em `/inscricao/termos/:inscricaoId`: após o aceite dos termos obrigatórios, a ação de finalizar valida a inscrição e, em caso de sucesso, conduz ao resumo com o número de protocolo em destaque.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de finalizar desabilitada com indicador enquanto valida e submete |
| Erro de validação | Lista os itens pendentes agrupados por categoria (campos, anexos e questões) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Gera o protocolo e conduz ao resumo da inscrição |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição completa é finalizada, gera número de protocolo e passa ao estado finalizada | cenário "Finalizar inscrição completa" |
| SC-02 | A finalização é impedida enquanto houver itens obrigatórios pendentes | cenário "Itens obrigatórios pendentes" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Finalizar Inscrição | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Finalizar Inscrição** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Finalizar Inscrição",
 "alr": ["Inscrição"],
 "der": ["ID Inscrição", "Termo de Aceite", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a transação grava a passagem a Finalizada, o número de protocolo e a data de finalização, e confere as respostas, os anexos e os aceites da própria inscrição

⚠️ Pelas regras 1 e 2, a finalização também consulta a obrigatoriedade configurada para a oferta (ALI *Tipo de Participante*) e os termos obrigatórios da premiação (ALI *Premiação*), que a planilha não conta como ALR. Se a equipe de métricas os contar, a EE passa a ALR 3 × DER 4, Média, 4 PF. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios cobertos da HU (sem numeração na fonte) na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
