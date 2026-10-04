<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-07
feature_set: AVL-ETA
dominio: AVL
entidade: Termo de Confidencialidade
data_model_ref: data-models/avaliacao.md#termo-de-confidencialidade
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-029_Termo_Confidencialidade_Avaliador
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

# Configurar Termo de Confidencialidade
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-07`

## Descrição
Permite ao administrador cadastrar, substituir ou desativar o termo de confidencialidade — em texto ou arquivo — exigido do avaliador na premiação.

Na aba "Avaliação & Etapas" da configuração da premiação, no bloco "Termo de Confidencialidade do Avaliador", o administrador escolhe o tipo do termo, escreve o texto ou anexa o arquivo e salva — ou desativa o termo vigente.

> ⚠️ Feature derivada do modelo de dados (`Termo de Confidencialidade`) e do N2; a HU específica do termo (HU-029) não faz parte deste lote — validar o conteúdo quando disponível.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-029_Termo_Confidencialidade_Avaliador`](../../../hus/HU-029_Termo_Confidencialidade_Avaliador.docx) | Criação | — funcionalidade *Configurar Termo de Confidencialidade da Premiação* da HU: cadastro em texto ou anexo, substituição do termo ativo e desativação, que remove o aceite obrigatório |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Avaliação & Etapas** → “Termo de Confidencialidade do Avaliador”)* (cadastro do termo de confidencialidade)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Uma premiação mantém no máximo um termo de confidencialidade ativo por vez.
2. O termo é fornecido de uma única forma por vez: texto ou arquivo anexo.
3. Substituir o termo desativa o termo anterior e passa o novo a ser o termo ativo da premiação.
4. O termo de confidencialidade ativo é exigido do avaliador antes do início das avaliações da premiação. ⚠️ *(o aceite do termo pelo avaliador é especificado em Avaliação de Projetos — AVL-AVA)*
5. O arquivo do termo respeita o tamanho e os tipos permitidos. → ver RULES-DICTIONARY: RC-08 — Arquivo com tamanho máximo (parâmetro: tamanho e tipos a confirmar ⚠️).

---

## Cenários

```gherkin
Feature: Configurar Termo de Confidencialidade

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar termo de confidencialidade em texto
    Given que a premiação não tem termo de confidencialidade ativo
    When escolho o tipo Texto, informo o conteúdo do termo e salvo
    Then o sistema registra o termo como ativo e exibe "Registro salvo com sucesso."

  Scenario: Cadastrar termo de confidencialidade como arquivo
    Given que a premiação não tem termo de confidencialidade ativo
    When escolho o tipo Arquivo, anexo o documento do termo e salvo
    Then o sistema registra o termo como ativo e exibe "Registro salvo com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Substituir o termo ativo
    Given que a premiação já tem um termo de confidencialidade ativo
    When cadastro um novo termo e salvo
    Then o sistema desativa o termo anterior e passa o novo a vigorar como termo ativo

  Scenario: Desativar o termo de confidencialidade
    Given que a premiação tem um termo de confidencialidade ativo
    When desativo o termo
    Then o sistema deixa a premiação sem termo de confidencialidade ativo

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Arquivo do termo acima do tamanho permitido
    Given que seleciono um arquivo de termo maior que o tamanho máximo
    When tento salvar
    Then o sistema rejeita e exibe "Arquivo excede o tamanho máximo de [tamanho]."
    # ← RULES-DICTIONARY: RC-08 — Arquivo com tamanho máximo

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de configuração
    Given que meu perfil não tem permissão para configurar o termo de confidencialidade
    When tento salvar o termo
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Título | Termo de Confidencialidade | entrada do usuário | editável | texto | não | máximo de 500 caracteres |
| Tipo do termo | Termo de Confidencialidade | entrada do usuário | editável | opção (Texto, Arquivo) | sim | define se o termo é fornecido como texto ou como arquivo |
| Texto do termo | Termo de Confidencialidade | entrada do usuário | editável | texto longo | condicional | obrigatório quando o Tipo do termo é Texto |
| Arquivo do termo | Termo de Confidencialidade | entrada do usuário | editável | arquivo | condicional | enviado como anexo; obrigatório quando o Tipo do termo é Arquivo; respeita tamanho e tipos permitidos ⚠️ |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do termo | Ativo | No cadastro de um novo termo |
| Situação do termo anterior | Inativo | Ao substituir o termo ativo |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Arquivo | grava | Guarda o documento do termo do tipo arquivo, com o tamanho e o tipo conferidos (regra 5) |

---

## Comportamento de tela

### Onde fica
Página do termo de confidencialidade em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Avaliação & Etapas** → “Termo de Confidencialidade do Avaliador”)*: seleção do tipo (texto ou arquivo), o editor de texto ou o campo de anexo conforme o tipo, e as ações de salvar e desativar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Sinaliza conteúdo do termo ausente ou arquivo fora do tamanho/tipo permitidos |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Sem termo ativo: convite a cadastrar o termo de confidencialidade |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um termo de confidencialidade (texto ou arquivo) é registrado como ativo na premiação | cenário "Cadastrar termo de confidencialidade em texto" |
| SC-02 | Cadastrar um novo termo desativa o termo anterior | cenário "Substituir o termo ativo" |
| SC-03 | O termo ativo pode ser desativado, deixando a premiação sem termo vigente | cenário "Desativar o termo de confidencialidade" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); critérios em prosa na `## Origem`, porque a HU não numera critérios; coluna Entidade em `## Campos`, com o Preenchimento normalizado; `## Dados lidos e gravados`; coluna Papel na tabela de `## Métricas de tamanho`, ainda sem processo elementar contado. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do modelo de dados e do N2 (HU-029 fora deste lote) |

---

*Feature Set: Etapas e Configuração da Avaliação · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
