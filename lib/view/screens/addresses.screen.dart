import 'package:flutter/material.dart';
import 'package:grocify/models/user.details.model.dart';
import 'package:provider/provider.dart';
import '../../view_model/addresses.view.model.dart';

class AddressesScreen extends StatelessWidget {
  static const String id = "addresses_screen";

  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final AddressesViewModel viewModel = AddressesViewModel();

    return ChangeNotifierProvider<AddressesViewModel>.value(
        value: viewModel,
        child: Consumer<AddressesViewModel>(
        builder: (context, viewModel, child) {
          viewModel.getAllAddresses();

          List<AddressModel> addressListWithSelected = viewModel.addresses.where((address) => address.selected).toList();
          List<AddressModel> addressListWithoutSelected = viewModel.addresses.where((address) => !address.selected).toList();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Indirizzi di spedizione',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
              shadowColor: Colors.black,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AddressDialog(vieModel: viewModel)
                );
              },
              backgroundColor: Colors.blue[900], // BlueDark equivalent
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.white,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      "Indirizzo corrente",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (addressListWithSelected.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Nessun indirizzo attualmente in uso",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  else
                      AddressCard(address: addressListWithSelected.first, viewModel: viewModel),

                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      "Indirizzi disponibili",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (addressListWithoutSelected.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          "Nessun altro indirizzo disponibile",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: addressListWithoutSelected.length,
                        itemBuilder: (context, index) {
                          return AddressCard(address: addressListWithoutSelected[index],viewModel: viewModel);
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        }
        )
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final AddressesViewModel viewModel;

  const AddressCard({super.key, required this.address, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: address.selected ? Colors.blue[900] : Colors.black,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${address.name}, ${address.city}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (String value) {
                    if(value == "Select"){
                      viewModel.setAddressSelected(address);
                    }else{
                      viewModel.deleteAddress(address);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      if (!address.selected)
                      const PopupMenuItem<String>(
                        value: 'Select',
                        child: Text('Seleziona'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Elimina'),
                      ),
                    ];
                  },
                ),
              ],
            ),
            Text(
              '${address.address}, ${address.civic}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}


class AddressDialog extends StatelessWidget {

  final AddressesViewModel vieModel;

  AddressDialog({super.key, required this.vieModel});

  late TextEditingController addressNameController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController civicController;

  @override
  Widget build(BuildContext context) {
    addressNameController = TextEditingController(text: "");
    cityController = TextEditingController(text: "");
    addressController = TextEditingController(text: "");
    civicController = TextEditingController(text: "");

    return AlertDialog(
      title: const Text(
        "Nuovo indirizzo",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,

        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTextField(
              controller: addressNameController,
              labelText: "Nome indirizzo",
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: cityController,
              labelText: "Città",
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: addressController,
              labelText: "Indirizzo",
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 10),

            _buildTextField(
              controller: civicController,
              labelText: "Civico",
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            "Indietro",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await vieModel.addAddress(
              addressNameController.text,
              addressController.text,
              cityController.text,
              civicController.text,
            );
            // Check if the context is still valid before using it
            if(context.mounted) {
              Navigator.pop(context, 'Cancel');
            }
          },
          child: const Text(
            "Aggiungi",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}