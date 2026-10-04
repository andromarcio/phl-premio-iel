<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-EMA-02
feature_set: CFG-EMA
dominio: CFG
entidade: Configuração de E-mail da Premiação
data_model_ref: data-models/configuracao.md#configuracao-de-e-mail-da-premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-021_Configurar_Templates_Email
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

# Editar Modelo de E-mail
> **Nível 3** - Feature Set: Modelos de E-mail — Major Feature Set: Configuração da Premiação - `CFG-EMA-02`

## Descrição
Permite ao administrador editar o assunto e o corpo de um modelo de e-mail com marcadores dinâmicos, ou restaurar o modelo ao padrão do sistema.

Na aba "Termos & E-mails" da configuração da edição, o administrador aciona a edição no cartão do tipo desejado e, no diálogo, altera o assunto e o corpo, insere marcadores pelos botões disponíveis e aciona "Salvar" — ou "Restaurar padrão", com confirmação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-021_Configurar_Templates_Email`](../../../hus/HU-021_Configurar_Templates_Email.docx) | Criação | — funcionalidade "Editar Template de E-mail" da HU (sem critérios numerados): assunto e corpo com marcadores dinâmicos e restauração do modelo padrão com confirmação |
| [`PDTIC25093-69`](../../../analise-impacto/AIM-PDTIC25093-69.md) | Alteração | — marcador `{{link_sistema}}` e o quinto tipo, Feedback disponível, editável como os demais |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Termos & E-mails** → diálogo do template)* (Diálogo de Edição de Modelo)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada edição tem o seu próprio conjunto de modelos, e a edição de um modelo não afeta o das demais edições.
2. Os marcadores dinâmicos disponíveis para o corpo são: {{nome_participante}}, {{titulo_premiacao}}, {{nome_categoria}}, {{nome_modalidade}}, {{numero_protocolo}}, {{texto_ajuste}}, {{texto_parecer}}, {{nome_administrador}} e **{{link_sistema}}** — este último, o endereço pelo qual o participante alcança o sistema, entrou na Sprint 6 com o modelo de feedback disponível.
3. Os marcadores são substituídos pelos valores reais somente no momento do envio do e-mail.
4. O assunto e o corpo são obrigatórios para salvar o modelo.
5. A restauração do modelo padrão exige confirmação e substitui o assunto e o corpo pelos do modelo padrão do sistema.

---

## Cenários

```gherkin
Feature: Editar Modelo de E-mail

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar assunto e corpo do modelo
    Given que abri um modelo de e-mail para edição
    When altero o assunto e o corpo e clico em "Salvar"
    Then o sistema grava o modelo e exibe "Registro salvo com sucesso."

  Scenario: Inserir um marcador no corpo
    Given que estou editando o corpo do modelo
    When insiro o marcador {{nome_participante}} no ponto escolhido
    Then o sistema adiciona o marcador ao corpo naquele ponto

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Assunto ou corpo em branco
    Given que estou editando um modelo de e-mail
    When deixo o assunto ou o corpo em branco e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Restaurar o modelo padrão
    Given que estou editando um modelo de e-mail personalizado
    When aciono "Restaurar padrão" e confirmo
    Then o sistema substitui o assunto e o corpo pelos do modelo padrão do sistema
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Assunto | Configuração de E-mail da Premiação | entrada do usuário | editável | texto | sim | assunto do e-mail enviado |
| Corpo do e-mail | Configuração de E-mail da Premiação | entrada do usuário | editável | texto longo | sim | conteúdo do e-mail, com marcadores dinâmicos |
| Tipo de e-mail | Configuração de E-mail da Premiação | exibido do cadastro | imutável | lista (Ajuste solicitado, Inscrição aprovada, Inscrição rejeitada, Devolução ao administrador, Feedback disponível) | — | define qual dos cinco modelos está sendo editado |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Diálogo de edição em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Termos & E-mails** → diálogo do template)*: campo de assunto, editor do corpo com botões de inserção de marcadores, alternância de pré-visualização e a ação de restaurar o modelo padrão.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo obrigatório com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de assunto e corpo de um modelo são persistidas | HU-021 (Editar Template de E-mail) |
| SC-02 | A restauração do modelo padrão substitui o assunto e o corpo, mediante confirmação | HU-021 (regra de restauração de padrão) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Editar Modelo de E-mail | principal | EE | 1 | 5 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Editar Template de E-mail*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Editar Modelo de E-mail** — EE · ALR 1 · DER 5 · Simples · 3 PF

```json
{"pe": "Editar Modelo de E-mail",
 "alr": ["Premiação"],
 "der": ["Tipo de E-mail", "Assunto do E-mail", "Corpo do E-mail", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a transação grava o assunto e o corpo do modelo, guardados na Configuração de E-mail da Premiação, subgrupo do arquivo lógico Premiação

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), conferência da HU na `## Origem` (a HU-021 não numera critérios) e prosa do ticket, coluna Entidade em `## Campos` (o Tipo do campo Tipo de e-mail, `seleção → tipo do modelo`, que não nomeava entidade, passa à lista dos cinco tipos), coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do marcador `{{link_sistema}}` e do quinto tipo de modelo. *Antes* eram oito marcadores e quatro tipos editáveis. *Agora* são **nove** marcadores — o novo é o endereço pelo qual o participante alcança o sistema, usado pelo e-mail de feedback disponível — e **cinco** tipos. O marcador é valor de um campo já existente (o corpo do modelo), não DER novo — sem Δ PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-021 |

---

*Feature Set: Modelos de E-mail · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
