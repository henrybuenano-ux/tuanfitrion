# Incidencia de deliverability (bounce) + remediación — tuAnfitrión

> Subcuenta GHL: **tuanfitrión** (`KwoLkmWJqTELiyXCqJ4f`) · 16 jun 2026

## Qué pasó
Se publicó la campaña Revenue y se **envió email masivo** a la base. GHL emitió aviso de
**"Non-compliant Bounce Rate"** y **suspendió el envío de correos** de la subcuenta.

- **Bounce rate: 4,62%** (límite permitido < 3%).
- Mensaje de GHL en la conversación: *"Your account has been suspended for sending further emails."*

## Causa raíz (diagnóstico sobre datos reales)
- **4.922 contactos**, 4.074 con email (83%).
- **92% (4.537) provienen de "Registro Turismo Andalucía"** → lista **raspada de un registro público, sin opt-in**.
- La sintaxis está bien (0 formato inválido), pero **formato válido ≠ buzón vivo**: muchos correos del registro están muertos/desactualizados + hay **spam-traps**.
- Señales de riesgo: **137 role-based** (`info@`, `reservas@`…), 7 con typo de dominio (`gmial/gamil`).

**Conclusión:** fue **cold email a una lista fría** desde la infraestructura de email de GHL (IP compartida), que **prohíbe el cold outreach**. Además es riesgo **RGPD/LSSI-CE** (enviar comercial sin base legal/opt-in).

## Remediación (orden)
1. **Parar:** NO usar "Retry Sending". Poner el workflow `Revenue · Secuencia 3 emails` en **Draft**. Cero envíos masivos hasta limpiar.
2. **Reactivar suspensión:** abrir ticket a HighLevel reconociendo el problema + plan (limpieza + validación + opt-in). *(Texto de ticket en el hilo de la sesión.)*
3. **Limpiar lista (obligatorio):** validación real de buzones (GHL Email Validation ~$2,50/1000, o NeverBounce/ZeroBounce/Bouncer). Suprimir hard bounces, role-based, typos y todo `invalid/unknown`. Reenviar solo a `deliverable`.
4. **Reencauce (para no repetir):** la **landing "análisis gratuito" ES el opt-in**. La lista fría del registro se toca por un **canal que tolere frío** (cold-email dedicado tipo Instantly/Smartlead con dominios dedicados + warmup, o ads/WhatsApp) → **se lleva a la landing** → quien pide el análisis **entra al nurture de GHL** (ya cálido, sin rebotes).

## Regla para el futuro
**GHL email marketing solo para contactos opt-in / engaged.** Nunca blastear listas raspadas desde GHL.
El outbound frío va por herramienta dedicada; GHL recibe solo a los que convierten en la landing.
