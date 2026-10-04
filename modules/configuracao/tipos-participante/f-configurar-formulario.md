<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-06
feature_set: CFG-TIP
dominio: CFG
entidade: Formulário Dinâmico
data_model_ref: data-models/configuracao.md#formulário-dinâmico
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-007_Configurar_Formulario_Tipo_Participante
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

# Configurar Formulário de Inscrição
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-06`

## Descrição
Permite ao administrador configurar o formulário de inscrição de um tipo de participante, escolhendo o modo de preenchimento em página única ou em etapas e organizando os campos e seções.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)* (Construtor de Formulário)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada tipo de participante mantém uma única configuração de inscrição vigente.
2. O modo de preenchimento é definido antes de a configuração ser concluída: página única ou em etapas.
3. No modo em etapas, há ao menos uma etapa configurada.
4. A configuração de inscrição é versionada: cada gravação bem-sucedida registra uma nova versão.
5. Um campo já respondido por inscrições existentes não é removido em definitivo; sua retirada é apenas lógica.

---

## Cenários

```gherkin
Feature: Configurar Formulário de Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Configurar formulário em página única
    Given que estou no construtor de formulário de um tipo de participante com campos adicionados
    When escolho o modo página única e salvo
    Then o sistema grava a configuração do formulário e registra uma nova versão

  Scenario: Configurar formulário em etapas
    Given que estou no construtor de formulário e escolho o modo em etapas
    When crio etapas nomeadas e associo campos a cada etapa e salvo
    Then o sistema grava o formulário com as etapas definidas e registra uma nova versão

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Salvar sem definir o modo de preenchimento
    Given que ainda não escolhi o modo de preenchimento do formulário
    When tento salvar
    Then o sistema não conclui a gravação enquanto o modo de preenchimento não for definido

  Scenario: Modo em etapas sem nenhuma etapa
    Given que escolhi o modo em etapas mas não criei nenhuma etapa
    When tento salvar
    Then o sistema não conclui a gravação enquanto não houver ao menos uma etapa

  Scenario: Campo sem rótulo ao salvar
    Given que existe um campo sem rótulo preenchido no formulário
    When tento salvar
    Then o sistema não conclui a gravação enquanto houver campo sem rótulo
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Modo de preenchimento | entrada do usuário | editável | lista (Página única, Em etapas) | sim | definido antes da conclusão da configuração |
| Título do formulário | entrada do usuário | editável | texto | não | máximo de 300 caracteres |
| Descrição do formulário | entrada do usuário | editável | texto longo | não | texto livre |
| Etapas | entrada do usuário | editável | lista de etapas nomeadas | condicional | ao menos uma no modo em etapas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Versão | Incrementada a cada gravação bem-sucedida | Ao salvar a configuração do formulário |

---

## Comportamento de tela

### Onde fica
Construtor de Formulário em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*: catálogo de tipos de campo à esquerda, área central para montagem e reordenação dos campos, painel de propriedades à direita, alternância entre página única e etapas no topo, além de pré-visualização e checklist de validação antes de salvar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | O checklist relaciona as pendências (modo não definido, etapa ausente, campo sem rótulo) e mantém o salvamento indisponível |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a nova versão do formulário |
| Empty state | Formulário sem campos: convite para arrastar um tipo de campo do catálogo |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O formulário só é gravado com o modo de preenchimento definido e, no modo em etapas, com ao menos uma etapa | Regras de negócio 2 e 3 (HU-007) |
| SC-02 | Cada gravação bem-sucedida registra uma nova versão do formulário | Critério de aceite 8 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Configurar Estrutura do Formulário de Inscrição | EE | 1 | 10 | Simples | 3 | 2026-02-28 |
| Consultar Estrutura do Formulário de Inscrição (implícita) | CE | 4 | 9 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Configurar Estrutura do Formulário de Inscrição** — ALR (1): Tipo Participante. DER (10): Cor primária · Fundo · Rótulos · Imagem Banner · Título · Subtítulo · Descrição Rica · Layout · Ação · Mensagem.

```json
{"pe": "Configurar Estrutura do Formulário de Inscrição",
 "alr": ["Tipo Participante"],
 "der": ["Cor primária", "Fundo", "Rótulos", "Imagem Banner", "Título", "Subtítulo", "Descrição Rica", "Layout", "Ação", "Mensagem"]}
```
- **Consultar Estrutura do Formulário de Inscrição (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (9): Cor primária · Fundo · Rótulos · Imagem Banner · Título · Subtítulo · Descrição Rica · Layout · Ação.

```json
{"pe": "Consultar Estrutura do Formulário de Inscrição (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Cor primária", "Fundo", "Rótulos", "Imagem Banner", "Título", "Subtítulo", "Descrição Rica", "Layout", "Ação"]}
```

**Total: 9 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
