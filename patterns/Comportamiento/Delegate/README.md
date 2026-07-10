# Delegate

Patrón de Comportamiento — Delegate

## Descripción

Delegate permite que un objeto delegue una responsabilidad a otro mediante un contrato definido por un protocolo. La clase que delega no necesita conocer la implementación concreta; solo necesita que el receptor cumpla con ese contrato.

Este enfoque favorece el bajo acoplamiento y deja la lógica de coordinación en un componente central.

## Problema que resuelve

Cuando varias clases deben colaborar, pero no conviene que una dependa directamente de otra, el patrón Delegate ayuda a:

- desacoplar al emisor y al receptor;
- evitar referencias rígidas entre clases;
- permitir que un objeto notifique eventos o solicitudes sin conocer quién las implementa.

## Ejemplo del proyecto

El ejemplo usa un restaurante para mostrar cómo interactúan diferentes actores:

- RestaurantManager: coordina el flujo general.
- Waiter: crea y actualiza órdenes.
- Chef: prepara los pedidos.

Las comunicaciones se establecen mediante protocolos como:

- WaiterInputDelegate
- WaiterOutputDelegate
- ChefInputDelegate
- ChefOutputDelegate

## Flujo del ejemplo

1. El administrador asigna mesas al mesero.
2. El mesero crea una orden y la envía al administrador.
3. El administrador delega la preparación de la orden al chef.
4. El chef notifica cuando la orden está lista.
5. El administrador reenvía la orden al mesero para su entrega.

## Características clave

- Protocolos para definir contratos.
- Referencias weak para evitar ciclos de retención.
- Separación de responsabilidades.
- Comunicación basada en eventos y delegación.

## Cuándo usarlo

Es útil cuando un objeto necesita notificar acciones o eventos a otro sin conocer su implementación concreta, especialmente en sistemas donde el acoplamiento debe mantenerse bajo.

## Archivos del ejemplo

- Playground: Delegate.playground
- Código de ejemplo: Contents.swift

Puedes abrir el playground para ver el flujo completo del patrón en acción.
