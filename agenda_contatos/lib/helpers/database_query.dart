
class DBquery {

  DBquery();

  String selectAll(String tableName) => "SELECT * FROM $tableName";
  String count(String tableName) => "SELECT COUNT(*) FROM $tableName";

  String createTable(String tableName, Map<String, String> columns){
    int _indexControll = 0;
    String sql = "CREATE TABLE $tableName(";

    columns.forEach((key, value) {
      _indexControll++;
      sql += "$key $value";
      if(columns.length > _indexControll) sql += ",";
      else sql += ")";
    });
    
    return sql;
  }

}