import 'package:flutter/material.dart';
import 'package:inventoryapp/models/category_model.dart';
import 'package:inventoryapp/screens/category_page.dart';
import 'package:inventoryapp/services/category_services.dart';
import 'package:inventoryapp/provider/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:collection/collection.dart';

class CategoryEdit extends StatefulWidget {
  final Category categoryObject;
  // const CategoryEdit({Key? key}) : super(key: key);
  // const CategoryEdit({super.key, required this.category});
  const CategoryEdit ({ Key? key, required this.categoryObject}): super(key: key);
  


  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
      
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CategoryService categoryService = CategoryService();
    _controller.text = widget.categoryObject.name.toString();

    return KeyboardDismisser(
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Inventory App'),
        backgroundColor: Color(0xff235d3a),
        ),
        // backgroundColor: Colors.grey[300],
        backgroundColor: Colors.white,
        body: Consumer<CategoryProvider>(
          builder: (context, categoryProvider, child) {
            if(categoryProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
                );
            }
          final categories = categoryProvider.categories;
          return SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // SizedBox(height: 25),
                Text(
                  'Edytuj kategorię',
                  // widget.categoryObject.categoryId.toString() + widget.categoryObject.name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      // initialValue: widget.categoryObject.name.toString(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Wprowadź nazwę kategorii',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),   
                      child: Center(
                        child: Text(
                          'Zapisz',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            
                          ),
                        ),
                      ),
                      ),
                    onTap: () {
                      Category? category = categories.firstWhereOrNull((x) => x.name == _controller.text.toString());
                      if (_controller.text.isEmpty) {
                        MotionToast.warning(
                                      title:  Text("UWAGA!"),
                                      description:  Text("Uzupełnij wszystkie wymagane pola.")
                                    ).show(context);
                        
                      } else if (category != null) {
                        MotionToast.error(
                                      title:  Text("BŁĄD!"),
                                      description:  Text("Istnieje już kategoria o wprowadzonej nazwie.")
                                    ).show(context);
                      } else {
                          Provider.of<CategoryProvider>(context, listen: false).editCategories(Category(
                            categoryId: widget.categoryObject.categoryId, 
                            name: _controller.text.toString()));
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoryPage()));
                      }
                    },
                  ),
                ),
          
              ]),
            ),
          );
          }
        ),
      ),
    );
  }


}