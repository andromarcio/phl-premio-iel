<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-08
feature_set: CFG-TIP
dominio: CFG
entidade: Campo do Formulário
data_model_ref: data-models/configuracao.md#campo-do-formulário
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

# Editar Campo
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-08`

## Descrição
Permite ao administrador alterar o rótulo, a obrigatoriedade e as demais propriedades de um campo já existente no formulário de inscrição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-007_Configurar_Formulario_Tipo_Participante`](../../../hus/HU-007_Configurar_Formulario_Tipo_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*); o campo selecionado é ajustado no painel de propriedades.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Todo campo, exceto o cabeçalho de seção, mantém um rótulo preenchido.
2. Um campo de seleção mantém ao menos uma opção disponível, manual ou proveniente de uma lista do sistema.
3. As alterações em um campo preservam as respostas já registradas por inscrições existentes. ⚠️ *(comportamento inferido da HU-007 para campos com inscrições — confirmar)*

---

## Cenários

```gherkin
Feature: Editar Campo

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Alterar o rótulo de um campo
    Given que selecionei um campo existente no formulário
    When altero o rótulo e salvo o formulário
    Then o sistema grava o novo rótulo do campo

  Scenario: Tornar um campo obrigatório
    Given que selecionei um campo opcional no formulário
    When marco o campo como obrigatório e salvo
    Then o sistema grava o campo como obrigatório

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Rótulo apagado na edição
    Given que estou editando um campo diferente de cabeçalho de seção
    When apago o rótulo e tento salvar o formulário
    Then o sistema não conclui a gravação e exibe "Campo obrigatório."

  Scenario: Remover todas as opções de um campo de seleção
    Given que edito um campo de seleção
    When removo todas as opções e não indico uma lista do sistema e tento salvar
    Then o sistema não conclui a gravação enquanto o campo de seleção não tiver ao menos uma opção
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Tipo de campo | entrada do usuário | editável | lista (Texto curto, Texto longo, Numérico, Data, E-mail, Seleção, Upload de arquivo, Cabeçalho de seção, Aceite de termo) | sim | alteração com ressalvas quando há inscrições ⚠️ |
| Rótulo | entrada do usuário | editável | texto | sim (exceto cabeçalho de seção) | máximo de 300 caracteres |
| Descrição do campo | entrada do usuário | editável | texto | não | texto de ajuda exibido ao candidato |
| Obrigatório | entrada do usuário | editável | booleano (sim/não) | não | padrão: não |
| Máscara | entrada do usuário | editável | lista (ex.: CPF, CNPJ, Telefone) | não | aplicável a campos de texto → ver FIELD-DICTIONARY: CPF |
| Opções | entrada do usuário | editável | lista de opções | condicional | obrigatório para campo de seleção; manual ou de uma lista do sistema |
| Largura em grade | entrada do usuário | editável | número (1 a 12) | não | padrão: 12 colunas |
| Ordem | entrada do usuário | editável | número | — | definida pela posição do campo no formulário |
| Etapa | entrada do usuário | editável | seleção → etapa do formulário | condicional | obrigatório quando o formulário está no modo em etapas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Ação no Construtor de Formulário (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Formulário de Inscrição**)*): o campo selecionado na área de montagem é ajustado no painel de propriedades à direita (seções Geral, Validação, Aparência e Visibilidade), com reflexo imediato na pré-visualização.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Sinaliza no checklist o campo sem rótulo ou o campo de seleção sem opções |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a alteração na pré-visualização |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de rótulo, obrigatoriedade e demais propriedades de um campo são persistidas | cenário "Alterar o rótulo de um campo" |
| SC-02 | A edição rejeita campo sem rótulo e campo de seleção sem opções | Regras de negócio 1 e 2 (HU-007) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Campo (implícito) | CE | 4 | 23 | Complexo | 6 | 2026-02-28 |
| Editar Campo | EE | 1 | 24 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

- **Consultar Campo (implícito)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (23): Rotulo · Descrição · Obrigatório · Tamanho · Máscara predefinida · Min caracteres · Max caracteres · Ícone · Tooltip · Placeholder · Tamanho · Espaçamento · Classe CSS · Opções (usar lista do sistema) · Valor · Texto exibido · Extensões permitidas · Tamanho máximo · Texto do cabeçalho · Texto do link · Título do Modal · Conteúdo · Ação.
- **Editar Campo** — ALR (1): Tipo Participante. DER (24): Rotulo · Descrição · Obrigatório · Tamanho · Máscara predefinida · Min caracteres · Max caracteres · Ícone · Tooltip · Placeholder · Tamanho · Espaçamento · Classe CSS · Opções (usar lista do sistema) · Valor · Texto exibido · Extensões permitidas · Tamanho máximo · Texto do cabeçalho · Texto do link · Título do Modal · Conteúdo · Ação · Mensagem.

**Total: 10 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-007 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
