$(document).on("turbolinks:load", function () {
  M.AutoInit();
  $("input.avatar").change(function () {
    var val = $(this).val();
    var path = val.replace(/\\/g, "/");
    var match = path.lastIndexOf("/");
    $("#avatar_file_name").val(match !== -1 ? val.substring(match + 1) : val);
  });
  console.log("load init on ready or turbolinks:load");
});

$(document).on("turbolinks:before-visit turbolinks:before-cache", function () {
  var elem = document.querySelector("#slide-out");
  if (elem) {
    var instance = M.Sidenav.getInstance(elem);
    if (instance) {
      if (instance.isOpen) {
        instance.close();
      }
      instance.destroy();
    }
  }
});

// $('#filename').css("display","inline-block");
//   $('#filename').val(match !== -1 ? val.substring(match + 1) : val);
// });
// $('#filename').bind('keyup, keydown, keypress', function() {
//   return false;
// });
// $('#filename, #btn').click(function() {
//   $('#files').trigger('click');
// });
