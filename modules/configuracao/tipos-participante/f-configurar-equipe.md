<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-15
feature_set: CFG-TIP
dominio: CFG
entidade: Configuração de Membro de Equipe
data_model_ref: data-models/configuracao.md#configuração-de-membro-de-equipe
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-006_Cadastrar_Tipo_Participantes
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

# Configurar Equipe
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-15`

## Descrição
Permite ao administrador configurar a inscrição em equipe de um tipo de participante, definindo os tipos de vínculo dos membros (ex.: Líder, Membro) e os campos extras coletados por membro.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Equipe**)* (Configuração de Equipe), habilitada quando o tipo permite inscrição em equipe.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A configuração de equipe só se aplica a tipos de participante que permitem inscrição em equipe.
2. Cada tipo de vínculo de membro tem um nome próprio dentro do tipo de participante.
3. Um campo extra de membro é opcional por padrão e pode ser definido como obrigatório.
4. A quantidade de membros da equipe observa o mínimo e o máximo definidos para o tipo de participante.

---

## Cenários

```gherkin
Feature: Configurar Equipe

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Definir tipo de vínculo de membro
    Given que o tipo de participante permite inscrição em equipe
    When cadastro o tipo de vínculo "Líder" e salvo
    Then o sistema registra o tipo de vínculo e exibe "Registro salvo com sucesso."

  Scenario: Adicionar campo extra de membro
    Given que estou na configuração de equipe do tipo de participante
    When adiciono o campo extra "Curso", defino-o como obrigatório e salvo
    Then o sistema passa a coletar o campo extra por membro da equipe

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Tipo de participante não permite equipe
    Given que o tipo de participante não permite inscrição em equipe
    When acesso a configuração de equipe
    Then o sistema mantém a configuração de equipe indisponível

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão para configurar equipe
    Given que meu perfil não tem permissão para configurar a equipe
    When tento acessar a configuração de equipe
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome do tipo de vínculo | entrada do usuário | editável | texto | sim | ex.: Líder, Membro; máximo de 200 caracteres |
| Nome do campo extra | entrada do usuário | editável | texto | não | campo adicional coletado por membro; máximo de 200 caracteres |
| Campo extra obrigatório | entrada do usuário | editável | booleano | não | padrão: não |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativa | Na criação do tipo de vínculo |
| Campo extra obrigatório | Não | Quando não definido pelo administrador |

---

## Comportamento de tela

### Onde fica
Tela de Configuração de Equipe do tipo de participante (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Equipe**)*): a lista dos tipos de vínculo de membro e os campos extras coletados por membro; a tela fica habilitada apenas quando o tipo permite inscrição em equipe.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo pendente com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a configuração de equipe |
| Empty state | Sem tipos de vínculo configurados: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Os tipos de vínculo e os campos extras dos membros são registrados para o tipo | cenários "Definir tipo de vínculo de membro" / "Adicionar campo extra de membro" |
| SC-02 | A configuração de equipe fica habilitada apenas quando o tipo permite inscrição em equipe | Critério de aceite 5 (HU-006) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Listar Configuração de Equipe | CE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Incluir Tipo de Vínculo | EE | 1 | 4 | Simples | 3 | 2026-02-28 |
| Consultar Tipo de Vínculo (implícita) | CE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Editar Tipo de Vínculo | EE | 1 | 4 | Simples | 3 | 2026-02-28 |
| Desativar Tipo de Vínculo | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Listar Configuração de Equipe** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome do Vínculo · Ordem · Ação.

```json
{"pe": "Listar Configuração de Equipe",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome do Vínculo", "Ordem", "Ação"]}
```
- **Incluir Tipo de Vínculo** — ALR (1): Tipo Participante. DER (4): Nome · Ordem · Ação · Mensagem.

```json
{"pe": "Incluir Tipo de Vínculo",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Ordem", "Ação", "Mensagem"]}
```
- **Consultar Tipo de Vínculo (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome · Ordem · Ação.

```json
{"pe": "Consultar Tipo de Vínculo (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome", "Ordem", "Ação"]}
```
- **Editar Tipo de Vínculo** — ALR (1): Tipo Participante. DER (4): Nome · Ordem · Ação · Mensagem.

```json
{"pe": "Editar Tipo de Vínculo",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Ordem", "Ação", "Mensagem"]}
```
- **Desativar Tipo de Vínculo** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Desativar Tipo de Vínculo",
 "alr": ["Tipo Participante"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 17 PF** (5 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (5 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 e do data-model (Tipo de Vínculo de Membro, Configuração de Membro de Equipe) ⚠️ HU-006 nomeia a aba Equipe; o detalhe de vínculos e campos extras deriva do data-model e do N2 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
