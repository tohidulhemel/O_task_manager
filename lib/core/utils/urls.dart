class Urls {
  static String baseURL = 'https://crud-api-ostad-live.onrender.com/api/v1';
  static String readProductURL =  '$baseURL/ReadProduct';
  static String createProductURL =  '$baseURL/CreateProduct';
  static String updateProduct(productID)=> '$baseURL/UpdateProduct/$productID';
  static String deleteProduct(productID)=> '$baseURL/DeleteProduct/$productID';
}