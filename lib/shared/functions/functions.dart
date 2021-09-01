

// fun to convert RawQuery type to List<Map<String, dynamic>>
List<Map<String, dynamic>> makeModifiableResults(
    List<Map<String, dynamic>> results) {
  // Generate modifiable
  return List<Map<String, dynamic>>.generate(
      results.length, (index) => Map<String, dynamic>.from(results[index]),
      growable: true);
}


// fun to assign images adn subTasks to notes and memories and tasks
List<Map<String, dynamic>> assignSubListToData(List<Map<String, dynamic>> data,
    List subData, String subDataKey, String subDataId) {
  List<Map<String, dynamic>> dataModified = makeModifiableResults(data);
  List<Map<String, dynamic>> sortedSubData = [];
  Map<String, dynamic> oneDataItem = {};
  List<Map<String, dynamic>> allDataWithSubData = [];

  for (int i = 0; i < dataModified.length; i++) {
    sortedSubData = [];
    oneDataItem = dataModified[i];
    oneDataItem.putIfAbsent(subDataKey, () => []);
    for (int y = 0; y < subData.length; y++) {
      if (dataModified[i]['id'] == subData[y][subDataId]) {
        sortedSubData.add(subData[y]);
      }
    }
    if (sortedSubData.isNotEmpty)
      oneDataItem.update(subDataKey, (dynamic val) => sortedSubData);
    allDataWithSubData.add(oneDataItem);
  }

  return allDataWithSubData;
}
