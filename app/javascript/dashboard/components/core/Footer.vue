<template>
  <v-footer
    id="dashboard-core-footer"
  >
    <v-container>
      <v-row
        align="center"
        no-gutters
      >

        <v-spacer class="hidden-sm-and-down" />

        <v-col
          cols="12"
          md="auto"
        >
          <div class="body-1 font-weight-light pt-6 pt-md-0 text-center">
            &copy; 2020, made by Fullout Engineer
          </div>
        </v-col>
      </v-row>
    </v-container>
  </v-footer>
</template>

<script>
  export default {
    name: 'DashboardCoreFooter',

  }
</script>

<style scoped>
  #dashboard-core-footer > a {
	font-size: 0.825rem;
	font-weight: 500;
	text-decoration: none;
	text-transform: uppercase;
  }


  .button {
    float: right;
    margin-right: 20px;
    width: 40px;
    height: 40px;
  }
  .white{
    background:white;
  }
  .black{
    background:black;
  }

  h1{
    padding-top: 1em;
    margin-top: 0px;
    text-align: center;
    color: white;
  }
  h3 {
    font-size: 1em;
  }
  p{
    font-size: 0.5em;
  }
  table {
    width: 100%;
    border-collapse: separate; 
  }
  tbody {
    width: 100%;
  }
  tr {
    transition: 0.7s;
    background-color: white;
    margin: 1em;
    right: 0px;
  }
  tr:first-child td:first-child { border-top-left-radius: 20px; }
  tr:first-child td:last-child { border-top-right-radius: 20px; }
  tr:last-child td:first-child { border-bottom-left-radius: 20px; }
  tr:last-child td:last-child { border-bottom-right-radius: 20px; }
  tr:hover {
    background-color: #ff8585;
    transition: 0.7s;
  }
  th{
    padding-left: 10px;
    padding-top: 5px;
  }
  td {
    padding-left: 10px;
    padding-right: 10px;
    border: 2px solid #ff4242;
    border-right-width: 0px;
    border-left-width: 0px;
    border-bottom-width: 0px; 
  }
  .title-url {
    padding-left: 10px;
    padding-right: 10px;
    border: 2px solid #ff4242;
    border-right-width: 0px;
    border-left-width: 0px;
    border-bottom-width: 0px; 
    width: 100%;
  }
  .ad-index{
    padding: 1em;
    background-color: #ff4242;
    transition: 1s;
    max-width: 80%;
    width: 80%;
    position: fixed;
    bottom: 0px;
  }

</style>