renderNewsItem = function(data) {
  var categories = ['Politics', 'Sports', 'Crime', 'Uncategorized'];
  var newsItem = "<tr id=\"" + data.item_digest +"\">";
  newsItem += "<td>" + data.title + "</td>";
  newsItem += "<td>"+ data.transformed_text + "</td>";
  newsItem += "<td>";
  for(var idx = 0; idx< categories.length; idx++) {
    newsItem += "<div><input type=\"checkbox\" class=\"categories\" id=\"" + data.item_digest + "_" +  categories[idx] + "\"/>" + categories[idx] + "</div>";
  }
  newsItem += "</td>"
  newsItem += "</tr>";
  $('#newsitems').append(newsItem);
};

displayNewsItems = function(e) {
  var news_items = e.news_items;
  for(var idx = 0; idx < news_items.length; idx++) {
    renderNewsItem(news_items[idx]);
  }
};

var item_categories = new Array();

findDuplicate = function(id) {
  for(var idx = 0;idx<item_categories.length;idx++) {
    if(item_categories[idx].id == id) return item_categories[idx];
  }
  return null;
}
submitStatus = function(index, element) { 
  if(!element.checked) return;
  var details = element.id.split('_');
  var category = findDuplicate(details[0])
  if(category != null) {
    category.categories.push(details[1]);
    return;
  }
  item_categories.push({id: details[0], categories: [details[1]]});
};

saveSucceeded = function(e) {
  alert('Save Succeeded. Loading next set...');
  item_categories = [];
  $('#newsitems').html('');
  loadNewsItems();
};

saveAll = function() {
  $('.categories').each(submitStatus);
  var jsonData = JSON.stringify(item_categories);
  $.ajax({
    url: '/update_category',
    type: "POST",
    data: jsonData,
    success: saveSucceeded
  });
};

loadNewsItems = function() {
  $.ajax({
    url: '/',
    success: displayNewsItems
  });
};

$(document).ready(function(e) {
  loadNewsItems();
  $('#saveall').click(saveAll);
});