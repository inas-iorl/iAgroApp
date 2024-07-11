import 'package:flutter/material.dart';

import '../models/device.dart';

class DeviceListWidget extends StatefulWidget {
  DeviceListWidget({required this.devices});

  List<DeviceModel> devices;

  @override
  State<DeviceListWidget> createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: const EdgeInsets.all(8),
      itemCount: widget.devices.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return DeviceListItemWidget(device: widget.devices[index]);
        // return ListTile(
        //   title: Text(widget.devices[index].name),
        //   subtitle: Text(widget.devices[index].id),
        // );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}


class DeviceListItemWidget extends StatefulWidget {
  DeviceListItemWidget({super.key, required this.device});

  DeviceModel device;

  @override
  State<DeviceListItemWidget> createState() => _DeviceListItemWidgetState();
}

class _DeviceListItemWidgetState extends State<DeviceListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        // color: Colors.indigo[50],
        decoration: BoxDecoration(
            color: Colors.indigo[50],
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(widget.device.name), Text(widget.device.id)],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: (){Navigator.of(context).pushNamed('/device', arguments: widget.device.id);},
                            icon: Icon(Icons.arrow_forward_ios_outlined))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
