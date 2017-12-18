var myApp = angular.module('myApp', ['ngMessages']);

myApp.controller('settingsController', function ($scope, $http, $window) {

  // Chef Tasks to bind the table
  $scope.chefTasks = [];

  $scope.machineip = '';
  $scope.machinename = '';      
  $scope.submitted = false;
  $scope.createMode = true;
  $scope.packageSelected = true;      

  $scope.allTools = [
    { 'id': 'jre-windows', 'name': 'Java', isChecked : false },
    { 'id': 'chrome-windows', 'name': 'Chrome', isChecked : false },
    { 'id': 'vs-windows', 'name': 'Visual Studio',  isChecked : false },
    { 'id': 'msoffice-windows', 'name': 'MS Office', isChecked : false },
    { 'id': 'firefox-windows', 'name': 'FireFox', isChecked : false },  
    { 'id': 'acrobatReader', 'name': 'Acrobat reader', isChecked : false },       
  ];      

  $scope.interacted = function (field) {
    // return $scope.submitted || field.$dirty;        
    return $scope.my_form.$dirty && field.$dirty;        
  };

  $scope.resetForm = function () {
    $scope.machineip = '';
    $scope.machinename = '';
    $scope.allTools.forEach(function(item){
      item.isChecked = false;
    });

    $scope.createMode = false;  

    $scope.packageSelected=true;        
    $scope.my_form.$setPristine();
    //$scope.my_form.$setValidity();
    $scope.my_form.$setUntouched();

    //not best practice still valid in this case
    var id_ipaddress = $window.document.getElementById('id_ipaddress');
    if (id_ipaddress !== undefined || id_ipaddress !== null) {
      id_ipaddress.focus();
    }        
  }

  $scope.checkPackageSelected = function(){
    $scope.packageSelected = $scope.allTools.filter(x=> x.isChecked === true).length > 0;
    return $scope.packageSelected;
  }

  $scope.addChefTask = function (my_form) {        
    $scope.checkPackageSelected();
    // Check if package is selected.
    if($scope.packageSelected){
      var selectedpackageIds = $scope.allTools.filter(x=>x.isChecked === true).map(function(item){            
              return item.id;
      });

      var selectedpackageNames = $scope.allTools.filter(x=>x.isChecked === true).map(function(item){            
              return item.name;
      });

      // Always include the package 'package-status' for each node.
      selectedpackageIds.push('package_status');

      var item = {
        name: $scope.machinename,
        ip: $scope.machineip,
        package: selectedpackageIds.toString(),
        packageNames: selectedpackageNames.toString()
      };        
      $scope.chefTasks.push(item);

      // Reset form fields.
      $scope.resetForm();          
    }
  }

  

  $scope.deleteChefTask = function (index) {
    if ($scope.chefTasks.length > 0) {
      $scope.chefTasks.splice(index, 1);
    }
  }

  $scope.submitTask = function () {
    $http.post('api/cheftasks', $scope.chefTasks).then(function (res) {
      alert('Chef Task submitted successfully ...!!!');
      $scope.resetForm();          
      $scope.chefTasks = [];
    }, function (err) {          
      alert('Error in submitting the Chef Task...!!!');
      $scope.resetForm();          
    })
  }
});