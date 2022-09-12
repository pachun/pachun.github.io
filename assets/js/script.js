const showMobileNavigationBar = function () {
  const navLinks = document.querySelector("#nav-links");
  navLinks.style.display = "none";

  const navContainer = document.querySelector("#nav-container");
  navContainer.style.marginLeft = "5%";
  navContainer.style.marginRight = "5%";

  const hamburgerButton = document.querySelector("#hamburger-button");
  hamburgerButton.style.display = "block";
};

const showDesktopNavigationBar = function () {
  const navLinks = document.querySelector("#nav-links");
  navLinks.style.display = "block";

  const navContainer = document.querySelector("#nav-container");
  navContainer.style.marginLeft = "30px";
  navContainer.style.marginRight = "30px";

  const hamburgerButton = document.querySelector("#hamburger-button");
  hamburgerButton.style.display = "none";
};

const keepPageResponsive = function (windowWidth) {
  const mobileThreshold = 700;

  if (windowWidth < mobileThreshold) {
    showMobileNavigationBar();
  } else {
    showDesktopNavigationBar();
  }
};

window.onresize = function () {
  const windowWidth = window.innerWidth;
  keepPageResponsive(windowWidth);
};

window.onload = function () {
  const windowWidth = window.innerWidth;
  keepPageResponsive(windowWidth);
};

const showMobileNavigationMenu = function () {
  const mobileNavigationMenu = document.querySelector("#mobile-nav-container");
  mobileNavigationMenu.style.display = "flex";
};

const hideMobileNavigationMenu = function () {
  const mobileNavigationMenu = document.querySelector("#mobile-nav-container");
  mobileNavigationMenu.style.display = "none";
};
