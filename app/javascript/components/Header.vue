<template>
   <!-- navbar -->
  <div class="navbar-wrapper">
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <!-- Responsive navbar -->
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span>
        </a>
          <h1 class="brand"><router-link :to="{ name: 'DashboardIndex' }">FO Analytics</router-link></h1>
          <!-- navigation -->
          <nav class="pull-right nav-collapse collapse">
            <ul id="menu-main" class="nav">
              <li><router-link :to="{ name: 'DashboardIndex' }">Setting</router-link></li>
            </ul>
          </nav>
        </div>
      </div>
    </div>
  </div>
</template>

<script></script>
<style scoped></style>