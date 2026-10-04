<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-03
feature_set: AVL-ETA
dominio: AVL
entidade: Etapa
data_model_ref: data-models/configuracao.md#etapa
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-024_Configurar_Etapas_de_Avaliacao
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

# Editar Etapa
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-03`

## Descrição
Permite ao administrador alterar o nome, o período, os perfis autorizados e os cortes de classificação e de premiação de uma etapa ainda aberta, sem mover a sua posição na sequência da premiação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-024_Configurar_Etapas_de_Avaliacao`](../../../hus/HU-024_Configurar_Etapas_de_Avaliacao.docx) | Criação | — |
| [`PDTIC25093-67`](../../../analise-impacto/AIM-PDTIC25093-67.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)* (diálogo Editor de Etapa, em modo edição)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/etapas-configuracao/flow.html`

---

</div>

## Regras de negócio

1. Uma etapa é editável apenas enquanto está na situação Aberta; uma etapa na situação Fechada não aceita alteração de dados.
2. Os cortes de classificação e de premiação de uma etapa fechada permanecem os que já foram materializados no resultado; alterá-los pressupõe a reabertura administrativa da etapa. → ver `AVL-APU-12` (Reabrir Etapa por UF), que é a feature responsável pela reabertura.
3. A data de término permanece maior ou igual à data de início após a edição. → ver RULES-DICTIONARY: Período de vigência (parâmetro: início ≤ término).
4. A lista de perfis autorizados permanece não vazia após a edição; os valores aceitos continuam sendo Administrador Nacional e Administrador Regional.
5. A quantidade de classificados — quantos participantes de cada grupo de disputa avançam para a etapa seguinte — permanece com valor mínimo um após a edição.
6. A quantidade de premiados continua opcional e independente da classificação: quando informada tem valor mínimo um; quando apagada, a etapa deixa de premiar, sem alterar a quantidade de classificados.
7. A abrangência do corte acompanha a **natureza da etapa** vigente após a edição: etapa **nacional** apura entre todos os inscritos, dentro de cada grupo; etapa **regional** apura por estado dentro de cada grupo. → ver `AVL-ETA-02` (Cadastrar Etapa), regra 9. ⚠️ *(não há campo próprio que declare a natureza da etapa: hoje ela é lida da lista de perfis autorizados — a etapa é regional quando o Administrador Regional consta nela e nacional quando não consta. Declarar a natureza como campo da etapa é alteração de modelo ainda a decidir — ver `ANALISE_IMPACTO_SP05.md`, *Definições ainda em aberto*)*
8. A ordem da etapa não é alterada na edição — a mudança de posição é uma ação própria de reordenação.
9. A data de liberação do feedback, quando informada, é igual ou posterior à data de término vigente após a edição.
10. Sem data de liberação informada, o feedback fica disponível ao participante assim que a consolidação da sua avaliação é concluída; com a data informada, fica disponível a partir dela. → ver `INS-ACO-02` (Visualizar Devolutiva)

---

## Cenários

```gherkin
Feature: Editar Etapa

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar nome, período e perfis de uma etapa aberta
    Given que selecionei uma etapa na situação Aberta
    When altero o nome, o período e os perfis autorizados e clico em "Salvar etapa"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  Scenario: Alterar os cortes de uma etapa aberta
    Given que selecionei uma etapa na situação Aberta com 3 em Quantidade de classificados
    When altero Quantidade de classificados para 5 e Quantidade de premiados para 2 e clico em "Salvar etapa"
    Then o sistema grava os novos cortes e exibe "Registro salvo com sucesso."

  Scenario: Remover o corte de premiação de uma etapa aberta
    Given que selecionei uma etapa aberta que premia 2 participantes por grupo
    When apago o campo Quantidade de premiados e clico em "Salvar etapa"
    Then o sistema grava a etapa sem corte de premiação e exibe "Registro salvo com sucesso."

  Scenario: Tornar a etapa regional
    Given que selecionei uma etapa aberta cujo corte vale por grupo
    When torno a etapa regional e clico em "Salvar etapa"
    Then o sistema grava a etapa e o cartão passa a apresentar os selos de classificados e de premiados com a abrangência por estado × grupo

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome da etapa apagado na edição
    Given que estou editando uma etapa
    When apago o campo Nome da etapa e clico em "Salvar etapa"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_SEM_PERFIL
  Scenario: Todos os perfis autorizados removidos
    Given que estou editando uma etapa
    When desmarco todos os perfis autorizados e clico em "Salvar etapa"
    Then o sistema não grava e exibe "Selecione pelo menos um perfil — etapa sem perfil autorizado não pode ser operada."

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_LIBERACAO_INVALIDA
  Scenario: Liberação do feedback anterior ao novo fim da etapa
    Given que antecipo a data de término para antes da data de liberação do feedback já gravada
    When clico em "Salvar etapa"
    Then o sistema não registra e exibe "A data de liberação do feedback deve ser igual ou posterior à data de fim da etapa."

  Scenario: Apagar a data de liberação do feedback
    Given que a etapa tem data de liberação do feedback informada
    When apago o campo e salvo
    Then o sistema registra a etapa e o feedback volta a ser liberado assim que a consolidação for feita

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_CLASSIFICADOS_INVALIDO
  Scenario: Quantidade de classificados zerada na edição
    Given que estou editando uma etapa aberta
    When apago o valor do campo Quantidade de classificados e clico em "Salvar etapa"
    Then o sistema não grava e exibe "Informe ao menos 1 classificado por grupo."

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_PREMIADOS_INVALIDO
  Scenario: Quantidade de premiados alterada para menos de um
    Given que estou editando uma etapa aberta que premia
    When informo zero no campo Quantidade de premiados e clico em "Salvar etapa"
    Then o sistema não grava e exibe "A quantidade de premiados deve ser ao menos 1. Deixe em branco se a etapa não premia."

  # ── Estados especiais ──────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_FECHADA_EDICAO
  Scenario: Tentar editar uma etapa fechada
    Given que a etapa está na situação Fechada
    When tento abrir a etapa para edição
    Then o sistema impede a edição e exibe "Etapa fechada não pode ser editada."

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_CORTE_BLOQUEADO
  Scenario: Tentar alterar os cortes de uma etapa fechada
    Given que a etapa está na situação Fechada e teve os cortes materializados no resultado
    When tento alterar Quantidade de classificados ou Quantidade de premiados
    Then o sistema mantém os cortes aplicados e exibe "Os cortes desta etapa já foram aplicados no resultado. Reabra a etapa para alterá-los."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome da etapa | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| Data de início | entrada do usuário | editável | data | sim | — |
| Data de término | entrada do usuário | editável | data | sim | maior ou igual à data de início |
| Perfis autorizados | entrada do usuário | editável | seleção múltipla (Administrador Nacional, Administrador Regional) | sim | ao menos um perfil selecionado |
| Quantidade de classificados | entrada do usuário | editável enquanto a etapa está Aberta | número inteiro | sim | mínimo 1 |
| Quantidade de premiados | entrada do usuário | editável enquanto a etapa está Aberta | número inteiro | não | mínimo 1 quando informada; em branco = a etapa não premia |
| Liberação do feedback | entrada do usuário | editável enquanto a etapa está Aberta | data | não | igual ou posterior à data de término; em branco = liberado assim que a consolidação for feita |
| Ordem | Etapa | somente leitura | número inteiro | — | posição na sequência; alterada apenas por reordenação |
| Situação | Etapa | somente leitura | Aberta ou Fechada | — | edição permitida apenas quando Aberta |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Abrangência do corte | Por grupo em etapa nacional; por estado × grupo em etapa regional | A cada gravação da etapa |

---

## Comportamento de tela

### Onde fica
Diálogo "Editor de Etapa" em modo edição, aberto pela ação "Editar" no cartão da etapa na aba "Avaliação & Etapas" (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*), pré-preenchido com os dados atuais, inclusive os dois cortes — Quantidade de classificados e Quantidade de premiados —, que ficam lado a lado com um texto de apoio traduzindo a abrangência vigente conforme os perfis marcados: "N por grupo" ou "N por estado × grupo". Com a etapa na situação Fechada os dois campos de corte ficam indisponíveis para alteração.

O cartão da etapa, de onde parte a edição, exibe os selos "Classificados" e "Premiados" com o valor e a abrangência de cada corte — "N por grupo" na etapa nacional, "N por estado × grupo" na regional; o selo "Premiados" fica ausente enquanto a etapa não premia. Concluída a gravação, os selos passam a mostrar os cortes recém-salvos.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar etapa" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome da etapa com "Campo obrigatório." e sinaliza período, perfis e cortes inválidos |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e fecha o editor, com os selos do cartão atualizados |
| Etapa fechada | Campos de corte indisponíveis; a tentativa de alterá-los exibe "Os cortes desta etapa já foram aplicados no resultado. Reabra a etapa para alterá-los." |
| Empty state | Ação "Editar" indisponível na etapa Fechada |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de nome, período e perfis de uma etapa aberta são persistidas | cenário "Editar nome, período e perfis de uma etapa aberta" |
| SC-02 | A edição de uma etapa fechada é impedida | cenário "Tentar editar uma etapa fechada" |
| SC-03 | A alteração das quantidades de classificados e de premiados de uma etapa aberta é persistida | cenário "Alterar os cortes de uma etapa aberta" |
| SC-04 | Apagar a quantidade de premiados deixa a etapa sem corte de premiação | cenário "Remover o corte de premiação de uma etapa aberta" |
| SC-05 | A alteração dos cortes de uma etapa fechada é impedida | cenário "Tentar alterar os cortes de uma etapa fechada" |
| SC-06 | A gravação com quantidade de classificados vazia ou menor que um é impedida | cenário "Quantidade de classificados zerada na edição" |
| SC-07 | Os selos do cartão passam a indicar a abrangência por estado × grupo quando a etapa passa a ser regional | cenário "Tornar a etapa regional" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Etapa (implícita) | CE | — | — | — | 0 | 2026-02-28 |
| Editar Etapa | EE | 1 | 7 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Etapa (implícita)** — ALR (0): —. DER (0): —. *Não contada: um processo elementar exige que os dados atravessem a fronteira, e a lista de etapas já exibe os campos que o formulário de edição abre preenchidos — nada cruza a fronteira de novo. Critério da equipe de métricas, registrado em 2026-09-02; ver a coluna Observação de `global/CONTAGEM-PF.md`.*

```json
{"pe": "Consultar Etapa (implícita)",
 "motivo": "um processo elementar exige que os dados atravessem a fronteira, e a lista de etapas já exibe os campos que o formulário de edição abre preenchidos — nada cruza a fronteira de novo. Critério da equipe de métricas, registrado em 2026-09-02; ver a coluna Observação de `global/CONTAGEM-PF.md`."}
```
- **Editar Etapa** — ALR (1): Premiação. DER (7): Nome da etapa · Início · Fim · Liberação do feedback · Operador da etapa · Ação · Mensagem.

```json
{"pe": "Editar Etapa",
 "alr": ["Premiação"],
 "der": ["Nome da etapa", "Início", "Fim", "Liberação do feedback", "Operador da etapa", "Ação", "Mensagem"]}
```

**Total: 3 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Contagem APF (docqui) | Memória complementada | A memória de `Consultar Etapa (implícita)` passa a dizer **por que** sai com ALR e DER zerados — critério de fronteira informado pela equipe de métricas. Antes a linha era indistinguível de contagem por preencher |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/etapas-configuracao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Especificação (docqui) | Referência corrigida | A reabertura era citada como `AVL-APU-08`, que na árvore é **Consultar Ranking da Etapa** — o ID certo é `AVL-APU-12` **Reabrir Etapa por UF**, e ela já tem N3 |
| 2026-09-01 | Decisões de produto (docqui) | Critério da abrangência trocado | A abrangência do corte passa a derivar da **natureza da etapa** — nacional apura entre todos os inscritos, regional apura por estado — e não mais da lista de perfis autorizados. A visibilidade da etapa por perfil passa a ser matriz do N2. ⚠️ Falta um campo que declare a natureza da etapa; hoje ela é lida dos perfis autorizados |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Revisão contra o sistema (docqui) | Feature alterada | Campo Liberação do feedback, que existia no editor e no modelo mas não fora capturado da HU-024 |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Edição dos cortes de classificação e de premiação, bloqueio do corte com a etapa fechada e selos de classificados/premiados no cartão |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-024 |

---

*Feature Set: Etapas e Configuração da Avaliação · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
