import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pj_shared_ui/pj_shared_ui.dart';
import 'package:pj_domain/pj_domain.dart';
import 'shipment_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:pj_l10n/pj_l10n.dart';

class ShipmentMonitorModule extends ConsumerWidget {
  const ShipmentMonitorModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentsAsync = ref.watch(shipmentListProvider);

    return shipmentsAsync.when(
      data: (shipments) => shipments.isEmpty 
          ? Center(child: Text(L10n.of(context)!.noShipmentsFound))
          : DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns:  [
                DataColumn2(label: Text(L10n.of(context)!.id), size: ColumnSize.S),
                DataColumn2(label: Text(L10n.of(context)!.origin), size: ColumnSize.L),
                DataColumn2(label: Text(L10n.of(context)!.destination), size: ColumnSize.L),
                DataColumn2(label: Text(L10n.of(context)!.weightLabel), size: ColumnSize.S),
                DataColumn2(label: Text(L10n.of(context)!.priceLabel), size: ColumnSize.S),
                DataColumn2(label: Text(L10n.of(context)!.shipmentStatus), size: ColumnSize.S),
              ],
              rows: shipments.map((s) => DataRow(
                cells: [
                  DataCell(Text(s.id.substring(0, 8))),
                  DataCell(Text(s.origin)),
                  DataCell(Text(s.destination)),
                  DataCell(Text("${s.weightKg} kg")),
                  DataCell(Text("\$${s.totalPrice}")),
                  DataCell(StatusBadge(
                    status: s.status,
                    label: switch (s.status) {
                      ShipmentStatus.pending => L10n.of(context)!.pending,
                      ShipmentStatus.inTransit => L10n.of(context)!.inTransit,
                      ShipmentStatus.delivered => L10n.of(context)!.delivered,
                      ShipmentStatus.reported => L10n.of(context)!.reported,
                    },
                  )),
                ],
              )).toList(),
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("${L10n.of(context)!.errorLoadingShipments}: $e")),
    );
  }
}
