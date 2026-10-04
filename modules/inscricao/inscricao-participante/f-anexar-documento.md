<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-05
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#documento-da-inscricao
endpoints: []
error_codes: []
depende_de: [INS-PAR-01]
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

# Anexar Documento
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-05`

## Descrição
Permite ao participante enviar os documentos obrigatórios e opcionais exigidos pela configuração de anexos da premiação, vinculando cada arquivo à inscrição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: `/inscricao/formulario/:inscricaoId` (capítulo de anexos do Formulário de Inscrição); dispara o envio de um arquivo.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Os documentos exigidos e os opcionais são os definidos pela configuração de anexos da premiação para a oferta da inscrição.
2. Cada arquivo enviado respeita as extensões permitidas e o tamanho máximo definidos na configuração de anexos → ver RULES-DICTIONARY: Arquivo com tamanho máximo.
3. Cada documento anexado fica vinculado à inscrição e ao ponto de anexo que o exige.
4. Um documento anexado pode ser substituído por outro enquanto a inscrição permanece editável.

---

## Cenários

```gherkin
Feature: Anexar Documento

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Anexar documento obrigatório
    Given que a inscrição exige um documento obrigatório
    When envio um arquivo dentro das extensões e do tamanho permitidos
    Then o sistema vincula o documento à inscrição
    And o item de anexo passa a constar como enviado

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Arquivo acima do tamanho máximo
    Given que o ponto de anexo tem um tamanho máximo definido
    When envio um arquivo maior que o permitido
    Then o sistema não anexa o documento e exibe "O arquivo excede o tamanho máximo permitido."
    # ← MESSAGE-DICTIONARY: INS_ANEXO_TAMANHO_EXCEDIDO

  Scenario: Extensão de arquivo não permitida
    Given que o ponto de anexo aceita apenas determinadas extensões
    When envio um arquivo com extensão não permitida
    Then o sistema não anexa o documento e exibe "Tipo de arquivo não permitido."
    # ← MESSAGE-DICTIONARY: INS_ANEXO_EXTENSAO_INVALIDA

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Substituir documento já anexado
    Given que já existe um documento anexado a um ponto de anexo
    When envio um novo arquivo para o mesmo ponto
    Then o sistema substitui o documento anterior pelo novo
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Arquivo | entrada do usuário | editável | upload de arquivo | conforme configuração | extensões e tamanho máximo conforme a configuração de anexos → ver RULES-DICTIONARY: Arquivo com tamanho máximo |
| Nome do arquivo | derivado do upload | somente leitura | texto | sim | nome do arquivo enviado |
| Configuração de anexo | contexto do ponto de anexo | somente leitura | referência → Configuração de Anexo | não | ponto de anexo que exige o documento |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Tipo MIME | Tipo do arquivo enviado | No envio do documento |
| Tamanho (bytes) | Tamanho do arquivo enviado | No envio do documento |
| Data do upload | Data e hora do envio | No envio do documento |

---

## Comportamento de tela

### Onde fica
Capítulo de anexos do formulário de inscrição em `/inscricao/formulario/:inscricaoId`, com a lista de documentos obrigatórios e opcionais, envio por ponto de anexo e indicação dos itens já enviados e pendentes.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Indicador de progresso do envio enquanto o arquivo é transferido |
| Erro de validação | Informa extensão não permitida ou arquivo acima do tamanho máximo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Vincula o documento e marca o item de anexo como enviado |
| Empty state | Nenhum documento enviado ainda: itens de anexo constam como pendentes |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um arquivo válido é vinculado à inscrição e o item de anexo passa a enviado | cenário "Anexar documento obrigatório" |
| SC-02 | Arquivo acima do tamanho máximo ou de extensão não permitida é recusado | cenários "Arquivo acima do tamanho máximo" e "Extensão de arquivo não permitida" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — passo dentro de cadastrar/editar inscrição. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
