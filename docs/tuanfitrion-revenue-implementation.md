# tuAnfitrión Performance — Revenue Management · Implementación GHL

> Subcuenta GHL: **tuanfitrión** (`KwoLkmWJqTELiyXCqJ4f`) · Generado 2026-06-16
> Aplicando `ghl-onboarding-mapper` (mapa) + `ghl-clickup-task-builder` (tareas).
> Estado: **construido por API, en DRAFT**. Faltan triggers de UI + publicar (ver checklist).

---

# PARTE A · MAPA (onboarding-mapper)

## A.1 · Objetivo
Generar **solicitudes de análisis gratuito** desde la base existente, convertirlas en oportunidades del pipeline Revenue y cerrar el servicio de Revenue Management (fee 7–10%).

## A.2 · Inventario de activos (IDs en vivo)

### Pipeline
| Nombre | ID | Fases |
|---|---|---|
| Revenue Performance - tuAnfitrión | `FqEQSDWchNq7OH9AJFf6` | Contacto impactado → Interesado → Análisis solicitado → Reunión agendada → Propuesta enviada → Cerrado ganado / Cerrado perdido |

### Tags (12)
| Tipo | Tags |
|---|---|
| Zona | `zona_costa_granada` · `zona_periferia` · `zona_granada_capital` · `zona_casas_rurales` |
| Fase | `rev_elegible` · `rev_impactado` · `rev_interesado` · `rev_analisis_solicitado` · `rev_reunion_agendada` · `rev_propuesta_enviada` · `rev_cerrado_ganado` · `rev_cerrado_perdido` |

### Custom Fields (4)
| Campo | Key |
|---|---|
| Zona | `contact.zona` |
| ADR medio | `contact.adr_medio` |
| Nº de apartamentos | `contact.n_de_apartamentos` |
| Facturación anual estimada | `contact.facturacin_anual_estimada` |

### Custom Values (2)
| Nombre | Merge tag | Valor actual |
|---|---|---|
| enlace_landing | `{{custom_values.enlace_landing}}` | ⚠️ placeholder — poner URL del form/landing |
| enlace_calendario | `{{custom_values.enlace_calendario}}` | ⚠️ placeholder — poner link de reserva |

### Formulario
| Nombre | ID |
|---|---|
| Solicitud Análisis Gratuito — tuAnfitrión | `7zx3TaixjOssL0DWr6VK` |

### Calendario
| Nombre | ID | Slug |
|---|---|---|
| Análisis Revenue – tuAnfitrión (round-robin, solo Henry) | `ymfy3UFugcbhOzwHeeV3` | `analisis-rev-v2` |

### Landing
HTML profesional autónomo entregado (hero + dolores + análisis gratuito + qué hacemos + ejemplo +9.900€ + CTA). Pegar en bloque *Custom Code* del funnel o alojar.

## A.3 · Nomenclatura
| Código | Significado |
|---|---|
| **LS01** | Lead Source — enrolamiento de la base (tag `rev_elegible`) |
| **SP01** | Secuencia 3 emails (nurture) |
| **SP02** | Clic email → Interesado |
| **SP03** | Análisis solicitado (form → confirmación + reserva) |
| **SP04** | WhatsApp nudge (re-engagement) |

## A.4 · Mapa visual (color-coded)
```
[LEAD SOURCE — AZUL]
└─ LS01 · Enrolamiento Base (manual al lanzar)
   ├─ Acción: Smart List por zona → Add Tag zona_* + rev_elegible
   └─ Efecto: entra en SP01

[SALES PIPELINE — VERDE]
├─ SP01 · Secuencia 3 emails        (trigger: Tag rev_elegible)
│  ├─ Add Tag: rev_impactado        → oportunidad en "Contacto impactado"
│  ├─ Email 1 (Impacto)  → enlace_landing
│  ├─ Wait 3 días
│  ├─ Email 2 (Autoridad) → enlace_landing
│  ├─ Wait 2 días
│  └─ Email 3 (Cierre)   → enlace_calendario
├─ SP02 · Clic email → Interesado   (trigger: Email Events = Clicked) ⚠️ UI
│  └─ Add Tag: rev_interesado       → mover oportunidad a "Interesado"
├─ SP03 · Análisis solicitado       (trigger: Form Submitted) ⚠️ UI
│  ├─ Add Tag: rev_analisis_solicitado → mover a "Análisis solicitado"
│  └─ Email confirmación → enlace_calendario
└─ SP04 · WhatsApp nudge            (trigger: Tag rev_interesado)
   ├─ WhatsApp 1
   ├─ Wait 3 días
   └─ WhatsApp 2

[CIERRE — manual por comercial]
└─ Mover oportunidad: Reunión agendada → Propuesta enviada → Cerrado ganado/perdido
   (+ tags rev_reunion_agendada / rev_propuesta_enviada / rev_cerrado_*)
```

## A.5 · Checklist de implementación
**Hecho (por API):** pipeline · 12 tags · 4 campos · 2 custom values · 4 workflows (DRAFT) · form · calendario · landing HTML.

**Pendiente (UI):**
- [ ] Rellenar `enlace_landing` + `enlace_calendario` con URLs reales
- [ ] SP02: añadir trigger **Email Events → Clicked**
- [ ] SP03: añadir trigger **Form Submitted → Solicitud Análisis Gratuito**
- [ ] Confirmar canal **WhatsApp** conectado (para SP04)
- [ ] Publicar los 4 workflows
- [ ] Montar landing en funnel (bloque Custom Code) y publicar

**Lanzamiento:** Smart List por zona → Add Tag `zona_*` + `rev_elegible` → arranca SP01.

---

# PARTE B · TAREAS CLICKUP (clickup-task-builder)
*1 subtarea = 1 nodo del builder. Cada subtarea: `## Acción en GHL` + `## Contexto`.*

## ▸ Tarea padre: WF-SP01 · SECUENCIA 3 EMAILS
```
## Descripción
Nurture de 3 emails que impacta a la base elegible y la dirige a la landing
de análisis gratuito. Es el corazón de "3 envíos por mes".

## Trigger
Tag Added → rev_elegible. Allow re-enrollment: OFF.

## Dependencias
- Pipeline Revenue Performance + etapa "Contacto impactado"
- Tags rev_elegible, rev_impactado · Custom value enlace_landing, enlace_calendario

## Estructura de nodos
| # | Tipo | Subtarea |
|---|---|---|
| 1 | Trigger | Trigger: Tag Added (rev_elegible) |
| 2 | Add Tag | Add Tag: rev_impactado |
| 3 | Send Email | Send Email: "¿estás perdiendo ingresos…" |
| 4 | Wait | Wait: 3 días |
| 5 | Send Email | Send Email: "un ejemplo real de +9.900€…" |
| 6 | Wait | Wait: 2 días |
| 7 | Send Email | Send Email: "cerramos la agenda…" |
```

**── Subtarea: Trigger: Tag Added (rev_elegible)**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Trigger | Contact Tag |
| Condición | Tag Added = rev_elegible |
| Re-enrollment | OFF |

## Contexto
El enrolamiento es manual: al lanzar una oleada se etiqueta la Smart List de
la zona con rev_elegible. Ese es el "enviar campaña".
```

**── Subtarea: Add Tag: rev_impactado**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Action type | Añadir etiqueta de contacto |
| Tag | rev_impactado |

## Contexto
Marca al contacto como impactado y sirve para crear/mover la oportunidad a
"Contacto impactado". Permite excluir luego a quien ya entró.
```

**── Subtarea: Send Email: "¿estás perdiendo ingresos…"**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Canal | Email |
| From Name | tuAnfitrión Performance |
| Asunto | {{contact.first_name}}, ¿estás perdiendo ingresos en tu apartamento turístico? |
| Cuerpo | HTML profesional (Impacto): dolor 12–27%, bullets, CTA → {{custom_values.enlace_landing}} |

## Contexto
Email 1 de 3. Personalizado con First Name. CTA lleva a la landing/formulario.
```

**── Subtarea: Wait: 3 días** · `## Acción en GHL` → Wait fijo 3 días · `## Contexto` espacia el envío 2.

**── Subtarea: Send Email: "un ejemplo real de +9.900€…"**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Asunto | {{contact.first_name}}, un ejemplo real de +9.900 € al año |
| Cuerpo | HTML (Autoridad): caja 55.000€→64.900€, CTA → {{custom_values.enlace_landing}} |

## Contexto
Email 2 (autoridad/prueba social). +3 días tras el Impacto.
```

**── Subtarea: Wait: 2 días** · Wait fijo 2 días.

**── Subtarea: Send Email: "cerramos la agenda…"**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Asunto | {{contact.first_name}}, cerramos la agenda de análisis esta semana |
| Cuerpo | HTML (Cierre): urgencia, CTA → {{custom_values.enlace_calendario}} |

## Contexto
Email 3 (cierre). Apunta directo a reservar en el calendario.
```

## ▸ Tarea padre: WF-SP02 · CLIC EMAIL → INTERESADO
```
## Descripción
Cuando un contacto hace clic en un email de la campaña, se marca como interesado
y se mueve en el pipeline. Alimenta SP04 (WhatsApp nudge).

## Trigger
Email Events → Clicked  ⚠️ se añade en UI (la API no engancha este trigger).

## Estructura de nodos
| # | Tipo | Subtarea |
|---|---|---|
| 1 | Trigger | Trigger: Email Events = Clicked |
| 2 | Add Tag | Add Tag: rev_interesado |
| 3 | Update Opp | Update Opportunity Stage → Interesado |
```

**── Subtarea: Trigger: Email Events = Clicked**
```
## Acción en GHL
⚠️ REVISAR — el trigger de email-click no se crea fiable por API interna.

Opciones:
A) UI: Add Trigger → "Email Events" → Event = Clicked (recomendado, 2 clics)
B) Filtrar por la campaña/workflow SP01 si se quiere acotar
→ Hacer en la UI antes de publicar.

## Contexto
El workflow ya existe con la acción de etiquetar lista; solo falta seleccionar
el trigger en el builder.
```

**── Subtarea: Add Tag: rev_interesado** · Action: Añadir etiqueta → rev_interesado · Contexto: dispara SP04.

**── Subtarea: Update Opportunity Stage → Interesado**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Action type | Update Opportunity Stage |
| Pipeline | Revenue Performance - tuAnfitrión |
| Etapa | Interesado |

## Contexto
Mover entre etapas requiere especificar pipeline + etapa (no es automático).
```

## ▸ Tarea padre: WF-SP03 · ANÁLISIS SOLICITADO
```
## Descripción
Al enviar el formulario, el contacto pasa a "Análisis solicitado", se le
confirma y se le envía el link de reserva del calendario.

## Trigger
Form Submitted → "Solicitud Análisis Gratuito"  ⚠️ se añade en UI.

## Estructura de nodos
| # | Tipo | Subtarea |
|---|---|---|
| 1 | Trigger | Trigger: Form Submitted (Solicitud Análisis Gratuito) |
| 2 | Add Tag | Add Tag: rev_analisis_solicitado |
| 3 | Update Opp | Update Opportunity Stage → Análisis solicitado |
| 4 | Send Email | Send Email: "tu análisis gratuito — reserva…" |
```

**── Subtarea: Trigger: Form Submitted (Solicitud Análisis Gratuito)**
```
## Acción en GHL
⚠️ REVISAR — el trigger Form Submitted no se crea fiable por API.

Opciones:
A) UI: Add Trigger → "Form Submitted" → seleccionar "Solicitud Análisis Gratuito"
→ Hacer en la UI antes de publicar.

## Contexto
Form ID 7zx3TaixjOssL0DWr6VK. Este trigger sustituye al de tag con que se creó
el WF (o el form puede añadir la tag rev_analisis_solicitado y mantener ese trigger).
```

**── Subtarea: Add Tag: rev_analisis_solicitado** · Action: Añadir etiqueta → rev_analisis_solicitado.

**── Subtarea: Update Opportunity Stage → Análisis solicitado** · Pipeline Revenue Performance · Etapa "Análisis solicitado".

**── Subtarea: Send Email: "tu análisis gratuito — reserva…"**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Asunto | {{contact.first_name}}, tu análisis gratuito — reserva tu hueco |
| Cuerpo | HTML confirmación, CTA → {{custom_values.enlace_calendario}} |

## Contexto
Confirma la solicitud y empuja a reservar en el calendario Análisis Revenue.
```

## ▸ Tarea padre: WF-SP04 · WHATSAPP NUDGE
```
## Descripción
Re-engagement por WhatsApp para interesados que no convirtieron aún.

## Trigger
Tag Added → rev_interesado.

## Estructura de nodos
| # | Tipo | Subtarea |
|---|---|---|
| 1 | Trigger | Trigger: Tag Added (rev_interesado) |
| 2 | Send WhatsApp | Send WhatsApp: "Hola {{first_name}} 👋…" |
| 3 | Wait | Wait: 3 días |
| 4 | Send WhatsApp | Send WhatsApp: "solo por confirmar…" |
```

**── Subtarea: Trigger: Tag Added (rev_interesado)** · Trigger Contact Tag = rev_interesado.

**── Subtarea: Send WhatsApp: "Hola {{first_name}} 👋…"**
```
## Acción en GHL
| Campo GHL | Valor |
|---|---|
| Canal | WhatsApp |
| Texto | Hola {{contact.first_name}} 👋 … análisis gratuito … ¿Te interesa? |

## Contexto
⚠️ WhatsApp: fuera de la ventana de 24h solo se envían templates aprobados por
Meta. Crear/aprobar template antes de go-live. Confirmar canal WhatsApp conectado.
```

**── Subtarea: Wait: 3 días** · Wait fijo 3 días.

**── Subtarea: Send WhatsApp: "solo por confirmar…"** · Texto: "{{contact.first_name}}, solo por confirmar — ¿quieres que revisemos tu apartamento sin coste?…"

---

# PARTE C · NOTAS DE LIMITACIONES (ghl-limitations)
- **Triggers email-click / form-submit**: no se enganchan fiable por API interna → se añaden en UI (2 clics). Los workflows ya tienen la acción lista.
- **Formulario**: creado por API con sus campos; el *nombre* se puso en UI (la API no lo acepta).
- **Mover entre etapas**: requiere especificar pipeline + etapa explícitamente.
- **WhatsApp**: ventana 24h → templates aprobados para mensajes fuera de ventana.
- **"Crear O Actualizar Oportunidad" está DEPRECADA** → usar "Crear oportunidad".
