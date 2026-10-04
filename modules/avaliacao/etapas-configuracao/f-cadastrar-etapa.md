---
id: AVL-ETA-02
feature_set: AVL-ETA
dominio: AVL
entidade: Etapa
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#etapa
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Cadastrar Etapa
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Domínio: Avaliação - `AVL-ETA-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador criar uma etapa eliminatória de avaliação com nome, período, perfis autorizados e os cortes de classificação e de premiação que ela aplica, posicionando-a ao final da sequência da premiação.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)* (diálogo Editor de Etapa, em modo criação)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/etapas-configuracao/flow.html`

---

</div>

## Regras de negócio

1. Uma premiação comporta no máximo cinco etapas sequenciais de avaliação.
2. As etapas são numeradas por uma ordem sequencial de 1 a N, atribuída automaticamente como a próxima posição livre na criação.
3. A data de término de uma etapa é maior ou igual à data de início. → ver RULES-DICTIONARY: Período de vigência (parâmetro: início ≤ término).
4. Cada etapa mantém uma lista não vazia de perfis autorizados a operá-la; os valores aceitos são Administrador Nacional e Administrador Regional.
5. Os perfis Participante e Avaliador não podem constar na lista de perfis autorizados de uma etapa — esses perfis acessam a etapa pelo vínculo de inscrição ou de alocação.
6. A lista de perfis autorizados de uma etapa vale para toda a sua operação; ela não é alterada pelo fechamento ou pela reabertura da etapa.
7. Cada etapa define uma quantidade de classificados — quantos participantes de cada grupo de disputa avançam para a etapa seguinte —, de valor mínimo um.
8. A quantidade de premiados é opcional e independente da classificação: quando informada tem valor mínimo um e determina quantos participantes de cada grupo de disputa são premiados; quando ausente, a etapa não premia.
9. A abrangência do corte deriva da **natureza da etapa**: a etapa **nacional** apura o corte entre todos os inscritos da etapa, dentro de cada grupo de disputa; a etapa **regional** apura por estado dentro de cada grupo. ⚠️ *(não há campo próprio que declare a natureza da etapa: hoje ela é lida da lista de perfis autorizados — a etapa é regional quando o Administrador Regional consta nela e nacional quando não consta. Declarar a natureza como campo da etapa é alteração de modelo ainda a decidir — ver `ANALISE_IMPACTO_SP05.md`, *Definições ainda em aberto*)*
10. A data de liberação do feedback, quando informada, é igual ou posterior à data de término da etapa.
11. Sem data de liberação informada, o feedback fica disponível ao participante assim que a consolidação da sua avaliação é concluída; com a data informada, fica disponível a partir dela. → ver `INS-ACO-02` (Visualizar Devolutiva)

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Criar etapa com dados válidos
  Given que a premiação tem menos de cinco etapas
  When informo nome, data de início, data de término e ao menos um perfil autorizado e salvo
  Then o sistema registra a etapa ao final da sequência e exibe "Registro salvo com sucesso."

Scenario: Criar etapa que também premia
  Given que estou criando uma etapa e informo 3 em Quantidade de classificados
  When informo 1 em Quantidade de premiados e salvo
  Then o sistema registra a etapa com os dois cortes e exibe "Registro salvo com sucesso."

Scenario: Criar etapa que apenas classifica
  Given que estou criando uma etapa e informo 5 em Quantidade de classificados
  When deixo Quantidade de premiados em branco e salvo
  Then o sistema registra a etapa sem corte de premiação e exibe "Registro salvo com sucesso."

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome da etapa em branco
  Given que estou criando uma etapa
  When deixo o campo Nome da etapa em branco e clico em "Salvar etapa"
  Then o sistema não registra e exibe "Campo obrigatório."

# ← MESSAGE-DICTIONARY: AVL_ETAPA_PERIODO_INVALIDO
Scenario: Data de término anterior à data de início
  Given que informo uma data de término anterior à data de início
  When clico em "Salvar etapa"
  Then o sistema não registra e exibe "Data de fim deve ser maior ou igual à data de início."

# ← MESSAGE-DICTIONARY: AVL_ETAPA_SEM_PERFIL
Scenario: Nenhum perfil autorizado selecionado
  Given que desmarco todos os perfis autorizados
  When clico em "Salvar etapa"
  Then o sistema não registra e exibe "Selecione pelo menos um perfil — etapa sem perfil autorizado não pode ser operada."

# ← MESSAGE-DICTIONARY: AVL_ETAPA_CLASSIFICADOS_INVALIDO
Scenario: Quantidade de classificados menor que um
  Given que informo zero no campo Quantidade de classificados
  When clico em "Salvar etapa"
  Then o sistema não registra e exibe "Informe ao menos 1 classificado por grupo."

# ← MESSAGE-DICTIONARY: AVL_ETAPA_PREMIADOS_INVALIDO
Scenario: Quantidade de premiados informada menor que um
  Given que informo zero no campo Quantidade de premiados
  When clico em "Salvar etapa"
  Then o sistema não registra e exibe "A quantidade de premiados deve ser ao menos 1. Deixe em branco se a etapa não premia."

# ← MESSAGE-DICTIONARY: AVL_ETAPA_LIBERACAO_INVALIDA
Scenario: Liberação do feedback anterior ao fim da etapa
  Given que informo uma data de liberação do feedback anterior à data de término
  When clico em "Salvar etapa"
  Then o sistema não registra e exibe "A data de liberação do feedback deve ser igual ou posterior à data de fim da etapa."

Scenario: Etapa sem data de liberação do feedback
  Given que estou preenchendo a etapa
  When deixo Liberação do feedback em branco e salvo
  Then o sistema registra a etapa e o feedback passa a ser liberado ao participante assim que a consolidação for feita

# ── Conflitos com dados existentes ─────────────────────────────

# ← MESSAGE-DICTIONARY: AVL_ETAPA_LIMITE
Scenario: Limite de cinco etapas atingido
  Given que a premiação já possui cinco etapas
  When tento adicionar mais uma etapa
  Then o sistema impede a criação e exibe "Esta premiação já atingiu o limite de cinco etapas."

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão de criação
  Given que meu perfil não tem permissão para cadastrar etapas
  When tento abrir o editor de nova etapa
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome da etapa | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| Data de início | entrada do usuário | editável | data | sim | — |
| Data de término | entrada do usuário | editável | data | sim | maior ou igual à data de início |
| Perfis autorizados | entrada do usuário | editável | seleção múltipla (Administrador Nacional, Administrador Regional) | sim | ao menos um perfil selecionado |
| Quantidade de classificados | entrada do usuário | editável | número inteiro | sim | mínimo 1 |
| Quantidade de premiados | entrada do usuário | editável | número inteiro | não | mínimo 1 quando informada; em branco = a etapa não premia |
| Liberação do feedback | entrada do usuário | editável | data | não | igual ou posterior à data de término; em branco = liberado assim que a consolidação for feita |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Ordem | Próxima posição livre na sequência | Na criação da etapa |
| Situação | Aberta | Na criação da etapa |
| Perfis autorizados (padrão) | Administrador Nacional e Administrador Regional | Na criação, antes de o administrador ajustar |
| Quantidade de classificados (padrão) | 1 | Na criação, antes de o administrador ajustar |

---

## Comportamento de tela

### Onde fica
Diálogo "Editor de Etapa" aberto pela ação "Nova etapa" na aba "Avaliação & Etapas" (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*): captura nome, período, liberação do feedback, perfis autorizados e os dois cortes; o subtítulo informa que a etapa entra ao final da sequência. Os campos de corte ficam lado a lado, com Quantidade de classificados já preenchida com 1 e Quantidade de premiados vazia; um texto de apoio sob os campos traduz a abrangência vigente conforme os perfis marcados — "N por grupo" ou "N por estado × grupo".

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar etapa" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome da etapa com "Campo obrigatório." e sinaliza período, perfis e cortes inválidos |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e fecha o editor |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma etapa com nome, período válido e ao menos um perfil é registrada ao final da sequência | cenário "Criar etapa com dados válidos" |
| SC-02 | A criação de uma sexta etapa é impedida | cenário "Limite de cinco etapas atingido" |
| SC-03 | A criação sem nenhum perfil autorizado é impedida | cenário "Nenhum perfil autorizado selecionado" |
| SC-04 | Uma etapa criada com quantidade de premiados em branco não aplica corte de premiação | cenário "Criar etapa que apenas classifica" |
| SC-05 | A criação com quantidade de classificados menor que um é impedida | cenário "Quantidade de classificados menor que um" |
| SC-06 | Uma etapa sem data de liberação libera o feedback na consolidação | cenário "Etapa sem data de liberação do feedback" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Cadastrar Nova Etapa | EE | 1 | 7 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Cadastrar Nova Etapa** — ALR (1): Premiação. DER (7): Nome da etapa · Início · Fim · Liberação do feedback · Operador da etapa · Ação · Mensagem.

```json
{"pe": "Cadastrar Nova Etapa",
 "alr": ["Premiação"],
 "der": ["Nome da etapa", "Início", "Fim", "Liberação do feedback", "Operador da etapa", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/etapas-configuracao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Critério da abrangência trocado | A abrangência do corte passa a derivar da **natureza da etapa** — nacional apura entre todos os inscritos, regional apura por estado — e não mais da lista de perfis autorizados. A visibilidade da etapa por perfil passa a ser matriz do N2. ⚠️ Falta um campo que declare a natureza da etapa; hoje ela é lida dos perfis autorizados |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Revisão contra o sistema (docqui) | Feature alterada | Campo Liberação do feedback, que existia no editor e no modelo mas não fora capturado da HU-024 |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Cortes de classificação e de premiação no editor; abrangência do corte derivada dos perfis autorizados |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-024 |

---

*Feature Set: Etapas e Configuração da Avaliação · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
