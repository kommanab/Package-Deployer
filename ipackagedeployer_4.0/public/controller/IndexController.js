var myApp = angular.module('myApp', ['ngMessages']);

    myApp.controller('settingsController', function ($scope, $http, $window) {

      $scope.selectedTech = '';
      $scope.tools = [];
      $scope.packages = [];
      $scope.machineip = '';
      $scope.machinename = '';
      $scope.selectedPackage = ''
      $scope.submitted = false;
      $scope.createMode = true;

      $scope.allTools = [
        { 'id': 'jre-windows', 'name': 'Java', isChecked : false },
        { 'id': 'chrome-windows', 'name': 'Chrome', isChecked : false },
        { 'id': 'firefox-windows', 'name': 'FireFox', isChecked : false },  
	{ 'id': 'acrobatReader', 'name': 'Acrobat reader', isChecked : false }, 
        { 'id': 'msoffice2013', 'name': 'MS Office', isChecked : false }, 
	{ 'id': 'vs-windows', 'name': 'Visual Studio',  isChecked : false }
      ];

      $scope.tools = $scope.allTools;

      $scope.interacted = function (field) {
        return $scope.submitted || field.$dirty;
      };

      $scope.onTechSelect = function () {

        if ($scope.selectedTech) {
          $scope.tools = [];
          $scope.allTools.forEach(function (item) {
            if (item.tech === $scope.selectedTech) {
              $scope.tools.push(item);
            }
          });
        }
        else {
          $scope.tools = $scope.allTools;
        }
      }

      $scope.addPackage = function () {
        $scope.submitted = true;

        var selectedpackageIds = $scope.allTools.filter(x=>x.isChecked === true).map(function(item){            
                return item.id;
        });

        var selectedpackageNames = $scope.allTools.filter(x=>x.isChecked === true).map(function(item){            
                return item.name;
        });

        var item = {
          name: $scope.machinename,
          ip: $scope.machineip,
          package: selectedpackageIds.toString(),
          packageNames: selectedpackageNames.toString()
        };        
        $scope.packages.push(item);

        $scope.submitted = false;  

        // Call the submit() - To be removed for table
        // $scope.submitTask();
      }

      $scope.newPackage = function () {
        $scope.machineip = '';
        $scope.machinename = '';
        $scope.selectedPackage = {};
        $scope.selectedTech = '';
        $scope.createMode = false;
        //not best practice still valid in this case
        var id_ipaddress = $window.document.getElementById('id_ipaddress');
        if (id_ipaddress !== undefined || id_ipaddress !== null) {
          id_ipaddress.focus();
        }
      }

      $scope.deletePackage = function (index) {
        if ($scope.packages.length > 0) {
          $scope.packages.splice(index, 1);
        }
      }

      $scope.submitTask = function () {
        $scope.submitted = true;

        $http.post('api/cheftasks', $scope.packages).then(function (res) {
          console.log(res.data);
          $scope.submitted = false;
          alert('Package created successfully ...!!!');
          $scope.packages = [];
        }, function (err) {
          $scope.submitted = false;
          alert('Error in creating the package...!!!')
        }
        )
      }
    });