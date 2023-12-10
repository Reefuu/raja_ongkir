// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

part of 'widgets.dart';

class CardProvince extends StatefulWidget {
  final Province prov;
  const CardProvince(this.prov);

  @override
  State<CardProvince> createState() => _CardProvinceState();
}

class _CardProvinceState extends State<CardProvince> {
  @override
  Widget build(BuildContext context) {
    Province p = widget.prov;
    return Card(
      color: Color(0xFFFFFFFF),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
        title: Text("${p.province}"),
        subtitle: Text("${p.provinceId}"),
        leading: Icon(Icons.location_city_rounded),
      ),
    );
  }
}
