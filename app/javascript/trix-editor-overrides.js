// Blacklist all file attachments
document.addEventListener("turbolinks:load", function() {
  window.addEventListener("trix-file-accept", function(event) {
    event.preventDefault();
    console.log('helloworld');
    alert("File attachment not supported!");
  });
});



// Only images

//window.addEventListener("trix-file-accept", function(event) {
//  const acceptedTypes = ['image/jpeg', 'image/png']
//  if (!acceptedTypes.includes(event.file.type)) {
//    event.preventDefault()
//    alert("Only support attachment of jpeg or png files")
//  }
//})

// File size
// window.addEventListener("trix-file-accept", function(event) {
//   const maxFileSize = 1024 * 1024 // 1MB 
//   if (event.file.size > maxFileSize) {
//     event.preventDefault()
//     alert("Only support attachment files upto size 1MB!")
//   }
// })