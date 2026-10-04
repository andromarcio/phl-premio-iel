<!-- docqui: 4.1.0 | prompt: PROMPT_1A | atualizado: 2026-10-04 -->
# Major Feature Set: Validação
> **Nível 1** - Visão estratégica do domínio - `VAL`

## Descrição
Responde pela conferência e pela decisão sobre as inscrições recebidas em cada UF, garantindo que apenas inscrições válidas avancem para a avaliação. Mantém o parecer de validação, as solicitações de ajuste ao participante e a auditoria das rodadas de ajuste. É consumido pela Avaliação, que recebe as inscrições aprovadas, e apoia-se no vínculo regional do administrador definido em Acesso e Gestão.

### O que este domínio NÃO faz
| Descrição | Pertence a |
|---|---|
| Preencher ou editar a inscrição (salvo os ajustes que o participante atende) | Inscrição |
| Avaliar o projeto e atribuir notas | Avaliação |
| Definir a estrutura e os termos conferidos na validação | Configuração da Premiação |
| Definir o vínculo do administrador às UFs | Acesso e Gestão |

---

## Feature Sets

| Feature Set | Descrição | Features |
|---|---|---|
| [**Fila e Painel de Validação**](./fila-validacao/README.md) <small>VAL-FIL</small> | Listar e filtrar as inscrições a validar e acompanhar o andamento consolidado | 3 |
| [**Análise e Decisão**](./analise-decisao/README.md) <small>VAL-ANA</small> | Analisar a inscrição, conferir dados/documentos/termos e aprovar ou rejeitar | 6 |
| [**Ajustes da Inscrição**](./ajustes/README.md) <small>VAL-AJU</small> | Solicitar ajustes ao participante e auditar as rodadas de ajuste | 4 |

---

## Regras transversais de negócio

1. Um administrador regional valida apenas inscrições das UFs a que está vinculado.
2. Toda decisão de validação (aprovar, rejeitar ou solicitar ajuste) é registrada com responsável, data e parecer.
3. Uma solicitação de ajuste abre uma rodada auditável; o histórico das rodadas é preservado (captura do estado a cada rodada).
4. Apenas inscrições aprovadas na validação avançam para a avaliação.
5. Enquanto uma inscrição está em ajuste, o participante pode atualizá-la conforme os itens solicitados.

---

## Integrações com outros domínios

### Leitura — domínios que consomem dados deste domínio
| Domínio | O que consome | Como |
|---|---|---|
| Avaliação | Inscrições aprovadas e o parecer de validação | a confirmar no PROMPT_1B |

### Escrita — domínios que criam ou alteram dados deste domínio
| Domínio | O que altera | Situação |
|---|---|---|
| Inscrição | Fornece as inscrições enviadas que a validação analisa | Ao enviar/reenviar a inscrição |
| Acesso e Gestão | Define o vínculo do administrador às UFs (escopo da validação) | Ao cadastrar administradores regionais |

---

<div class="dev-only">

## Entidades do domínio

> Campos completos no data-model — ver `global/data-models/validacao.md`.

| Entidade | Descrição | Campos no DATA-MODEL.md |
|---|---|---|
| Validação de Inscrição | Decisão e parecer da validação | → ver DATA-MODEL.md: Validação de Inscrição |
| Auditoria de E-mail | Registro dos e-mails disparados (auditoria) | → ver DATA-MODEL.md: Auditoria de E-mail |

> **ALIs deste domínio** (2): Validação Inscrição · Auditoria de E-mails — 20 PF (baseline APF). Itens de ajuste e histórico da inscrição residem fisicamente em Inscrição. Ver `global/data-models/validacao.md`.

</div>

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0: carimbo, título `# Major Feature Set:`, contagem de features por Feature Set conferida com os N3 existentes (fila-validacao 2→3, analise-decisao 4→6, ajustes 3→4) e rodapé com os links dos Feature Sets. Seções técnicas do 1B (dependências externas, regras de acesso consolidadas) seguem fora do escopo do perfil `requisitos` |
| 2026-08-25 | Engenharia reversa (docqui) | N1 negocial criado | Domínio derivado do N0, das HUs e do data-model |

---

*Última revisão: 2026-10-04*

*Links: [Fila e Painel de Validação](./fila-validacao/README.md) `VAL-FIL` · [Análise e Decisão](./analise-decisao/README.md) `VAL-ANA` · [Ajustes da Inscrição](./ajustes/README.md) `VAL-AJU` · [INDEX geral](../INDEX.md)*
