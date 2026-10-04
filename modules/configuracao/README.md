<!-- docqui: 4.1.0 | prompt: PROMPT_1A | atualizado: 2026-10-04 -->
# Major Feature Set: Configuração da Premiação
> **Nível 1** - Visão estratégica do domínio - `CFG`

## Descrição
Responde por toda a montagem e a parametrização de uma edição da premiação, sendo a fonte única da estrutura que as demais áreas consomem: categorias, modalidades, tipos de participante e suas ofertas, formulários de inscrição, questionários de avaliação, etapas, modelos de e-mail e critérios de avaliação. Mantém essa estrutura de forma reaproveitável entre edições, categorias e modalidades. É consumido por Inscrição, Validação e Avaliação sempre que precisam da estrutura da edição vigente.

### O que este domínio NÃO faz
| Descrição | Pertence a |
|---|---|
| Preencher e enviar inscrições | Inscrição |
| Validar ou aprovar inscrições | Validação |
| Alocar avaliadores, apurar notas e configurar etapas de avaliação | Avaliação |
| Gerir identidade, perfis e acesso dos usuários | Acesso e Gestão |

---

## Feature Sets

| Feature Set | Descrição | Features |
|---|---|---|
| [**Prêmios**](./premios/README.md) <small>CFG-PRE</small> | Criar e manter a edição da premiação: dados, identidade visual, links públicos, termos de aceite e critérios de avaliação | 13 |
| [**Categorias**](./categorias/README.md) <small>CFG-CAT</small> | Cadastrar e manter categorias e vinculá-las às edições | 5 |
| [**Modalidades**](./modalidades/README.md) <small>CFG-MOD</small> | Cadastrar e manter modalidades e vinculá-las às categorias da edição | 5 |
| [**Tipos de Participante**](./tipos-participante/README.md) <small>CFG-TIP</small> | Cadastrar o tipo de participante e sua estrutura de inscrição: formulário dinâmico, enquadramentos, anexos exigidos, questionário de avaliação e configuração de equipe | 16 |
| [**Vínculos e Ofertas**](./ofertas/README.md) <small>CFG-VIN</small> | Compor a oferta de inscrição cruzando tipo de participante × modalidade × categoria (submodalidade) | 11 |
| [**Listas do Sistema**](./listas-sistema/README.md) <small>CFG-LIS</small> | Manter listas de valores reutilizáveis pelo sistema | 5 |
| [**Modelos de E-mail**](./modelos-email/README.md) <small>CFG-EMA</small> | Configurar os modelos de e-mail transacional da edição | 3 |

---

## Regras transversais de negócio

1. Toda estrutura de configuração existe no contexto de uma premiação (edição) — categorias, modalidades, tipos de participante e ofertas pertencem a uma edição.
2. A exclusão de itens de configuração é lógica (inativação); registros já usados por inscrições não são removidos fisicamente.
3. A estrutura de uma edição é reaproveitável — pode ser copiada, duplicada ou vinculada a uma nova edição.
4. Cada tipo de participante tem, no máximo, um formulário de inscrição e um questionário de avaliação vigentes.
5. Uma oferta (submodalidade) é única para a combinação tipo de participante × modalidade × categoria dentro da edição.
6. Alterações na estrutura após o início das inscrições não afetam retroativamente inscrições já enviadas. ⚠️ *(confirmar)*

---

## Integrações com outros domínios

### Leitura — domínios que consomem dados deste domínio
| Domínio | O que consome | Como |
|---|---|---|
| Inscrição | Oferta, formulário dinâmico, anexos exigidos, termos de aceite, link público | a confirmar no PROMPT_1B |
| Validação | Estrutura da edição e termos, para conferência | a confirmar no PROMPT_1B |
| Avaliação | Questionário de avaliação, critérios de avaliação e etapas da edição | a confirmar no PROMPT_1B |

### Escrita — domínios que criam ou alteram dados deste domínio
| Domínio | O que altera | Situação |
|---|---|---|
| — | (apenas administradores, pelas features deste domínio) | — |

---

<div class="dev-only">

## Entidades do domínio

> Campos completos no data-model — ver `global/data-models/configuracao.md`.

| Entidade | Descrição | Campos no DATA-MODEL.md |
|---|---|---|
| Premiação | Edição da premiação e seus parâmetros | → ver DATA-MODEL.md: Premiação |
| Categoria | Categoria da premiação | → ver DATA-MODEL.md: Categoria |
| Modalidade | Modalidade vinculada à categoria da edição | → ver DATA-MODEL.md: Modalidade |
| Tipo de Participante | Tipo de participante e sua estrutura de inscrição/avaliação | → ver DATA-MODEL.md: Tipo de Participante |
| Listas do Sistema | Listas de valores reutilizáveis | → ver DATA-MODEL.md: Listas do Sistema |

> **ALIs deste domínio** (5): Premiação · Categoria · Modalidade · Tipo de Participante · Listas do Sistema — 43,5 PF (baseline APF). Ver `global/data-models/configuracao.md`.

</div>

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0: carimbo, título `# Major Feature Set:`, contagem de features por Feature Set conferida com os N3 existentes (premios 12→13) e rodapé com os links dos Feature Sets. Seções técnicas do 1B (dependências externas, regras de acesso consolidadas) seguem fora do escopo do perfil `requisitos` |
| 2026-08-25 | Engenharia reversa (docqui) | N1 negocial criado | Domínio derivado do N0, das HUs e do data-model |

---

*Última revisão: 2026-10-04*

*Links: [Prêmios](./premios/README.md) `CFG-PRE` · [Categorias](./categorias/README.md) `CFG-CAT` · [Modalidades](./modalidades/README.md) `CFG-MOD` · [Tipos de Participante](./tipos-participante/README.md) `CFG-TIP` · [Vínculos e Ofertas](./ofertas/README.md) `CFG-VIN` · [Listas do Sistema](./listas-sistema/README.md) `CFG-LIS` · [Modelos de E-mail](./modelos-email/README.md) `CFG-EMA` · [INDEX geral](../INDEX.md)*
