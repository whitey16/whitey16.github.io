
// const json = {
//   "companies": [
//     {
//       "id": "118715-14",
//       "name": "Didi Chuxing",
//       "valuation": 60.0,
//       "totalRaised": 12.9,
//       "city": "Beijing",
//       "state": "",
//       "country": "China",
//       "industry": "Social/Platform Software",
//       "logo_src": "'./resources/images/Didi_Chuxing_logo.png'"
//     },
//     {
//       "id": "118715-14",
//       "name": "Didi Chuxing",
//       "valuation": 60.0,
//       "totalRaised": 12.9,
//       "city": "Beijing",
//       "state": "",
//       "country": "China",
//       "industry": "Social/Platform Software",
//       "logo_src": "'./resources/images/Didi_Chuxing_logo.png'"
//     },
//     {
//       "id": "51136-75",
//       "name": "Uber Technologies",
//       "valuation": 69.0,
//       "totalRaised": 14.7,
//       "city": "San Francisco",
//       "state": "CA",
//       "country": "United States",
//       "industry": "Social/Platform Software",
//       "logo_src": "'./resources/images/uber_logo.png'"
//     }
//   ]
// }
//
// const tableData = [];
// const otherData = [];



// const companies = json.companies;
// const table = document.getElementsByClassName("table-body");

$(document).ready(function(){
  $('#unicorns').DataTable({
    "ajax": {
      "url": "//files.pitchbook.com/website/files/txt/companies.txt",
      "dataSrc": "companies"
    },
    "paging": false,
    "info": false,
    "order": [1 ,"desc"]//orders valuation descending by defualt
  });
  // const table = $("tbody");
  // const companies = json.companies;
  // console.log(companies[1].name);
  // let newBody = $("<tbody class='table-body'>");
  //
  // companies.forEach(company => {
  //   let rowClass = 'odd';
  //   let newRow = $("<tr role='row' class='"+rowClass+"'>");
  //
  //   newRow.append($('<td class="company-block"><div class="logo-block"><img src='+company.logo_src+'alt=""></div><a href="#" target="_blank">'+company.name+'</a></td>'))
  //         .append($("<td>"+company.valuation+"</td>"))
  //         .append($("<td>"+company.totalRaised+"</td>"))
  //         .append($("<td>"+company.city+"</td>"))
  //         .append($("<td>"+company.industry+"</td>"));
  //
  //   newBody.append(newRow);
  //
  //   if(rowClass === 'odd') {
  //     rowClass = 'even';
  //   } else {
  //     rowClass = 'odd';
  //   }
  //
  //   console.log(rowClass);
  //   });
  // table.replaceWith(newBody);
});
