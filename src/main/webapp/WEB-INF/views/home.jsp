
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Muli – Thư Viện Âm Nhạc</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;1,9..40,300&family=Space+Mono:wght@400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

<style>
/* ================================================================
   GLOBAL RESET & CSS VARIABLES
================================================================ */
*,*::before,*::after{margin:0;padding:0;box-sizing:border-box}
:root{
  --bg-primary:#0a0a0f;
  --bg-secondary:#111118;
  --bg-card:#16161f;
  --bg-glass:rgba(22,22,31,0.75);
  --accent-1:#e8ff47;
  --accent-2:#ff3c6e;
  --accent-3:#3cf0c5;
  --text-primary:#f0f0f5;
  --text-muted:#7a7a8c;
  --text-dim:#44445a;
  --border:rgba(255,255,255,0.06);
  --border-hover:rgba(232,255,71,0.3);
  --header-h:72px;
  --sidebar-w:260px;
  --radius-sm:8px;
  --radius-md:16px;
  --radius-lg:24px;
  --shadow-glow:0 0 40px rgba(232,255,71,0.12);
  --shadow-card:0 8px 32px rgba(0,0,0,0.45);
  --transition:cubic-bezier(0.23,1,0.32,1);
}
html{scroll-behavior:smooth}
body{font-family:'DM Sans',sans-serif;background:var(--bg-primary);color:var(--text-primary);min-height:100vh;overflow-x:hidden}
::-webkit-scrollbar{width:6px}
::-webkit-scrollbar-track{background:var(--bg-primary)}
::-webkit-scrollbar-thumb{background:var(--text-dim);border-radius:3px}
::-webkit-scrollbar-thumb:hover{background:var(--accent-1)}

/* ================================================================
   KEYFRAMES
================================================================ */
@keyframes slideDown{from{transform:translateY(-100%);opacity:0}to{transform:translateY(0);opacity:1}}
@keyframes fadeInLeft{from{transform:translateX(-30px);opacity:0}to{transform:translateX(0);opacity:1}}
@keyframes navbarSlide{from{opacity:0;transform:translateY(-8px)}to{opacity:1;transform:translateY(0)}}
@keyframes playerSlideUp{from{transform:translateY(100%);opacity:0}to{transform:translateY(0);opacity:1}}
@keyframes fadeSlideIn{from{opacity:0;transform:translateX(-10px)}to{opacity:1;transform:translateX(0)}}
@keyframes pulse-logo{0%,100%{box-shadow:0 0 0 0 rgba(232,255,71,0.4)}50%{box-shadow:0 0 0 12px rgba(232,255,71,0)}}
@keyframes spin{to{transform:rotate(360deg)}}
@keyframes ping{0%,100%{transform:scale(1)}50%{transform:scale(1.15)}}
@keyframes errorShake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-4px)}40%,80%{transform:translateX(4px)}}
@keyframes titleReveal{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}

/* ================================================================
   HEADER
================================================================ */
.site-header{position:fixed;top:0;left:0;right:0;height:var(--header-h);z-index:1000;background:var(--bg-glass);backdrop-filter:blur(20px) saturate(180%);-webkit-backdrop-filter:blur(20px) saturate(180%);border-bottom:1px solid var(--border);display:flex;align-items:center;padding:0 24px;gap:24px;animation:slideDown 0.6s var(--transition) both}
.header-logo{display:flex;align-items:center;gap:10px;text-decoration:none;flex-shrink:0}
.logo-icon{width:40px;height:40px;background:linear-gradient(135deg,var(--accent-1),var(--accent-3));border-radius:var(--radius-sm);display:flex;align-items:center;justify-content:center;font-size:18px;color:var(--bg-primary);animation:pulse-logo 3s ease-in-out infinite}
.logo-text{font-family:'Bebas Neue',cursive;font-size:26px;letter-spacing:2px;color:var(--text-primary);line-height:1}
.logo-text span{color:var(--accent-1)}
.header-search{flex:1;max-width:520px;position:relative}
.header-search input{width:100%;height:42px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:100px;padding:0 16px 0 44px;color:var(--text-primary);font-family:'DM Sans',sans-serif;font-size:14px;outline:none;transition:all 0.3s var(--transition)}
.header-search input::placeholder{color:var(--text-dim)}
.header-search input:focus{border-color:var(--accent-1);background:rgba(232,255,71,0.04);box-shadow:0 0 0 3px rgba(232,255,71,0.08),var(--shadow-glow)}
.search-icon{position:absolute;left:15px;top:50%;transform:translateY(-50%);color:var(--text-muted);font-size:14px;pointer-events:none;transition:color 0.3s}
.header-search input:focus~.search-icon{color:var(--accent-1)}
.search-dropdown{position:absolute;top:calc(100% + 8px);left:0;right:0;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);box-shadow:var(--shadow-card);overflow:hidden;opacity:0;transform:translateY(-8px);pointer-events:none;transition:all 0.25s var(--transition);z-index:200}
.header-search input:focus~.search-dropdown{opacity:1;transform:translateY(0);pointer-events:auto}
.search-suggestion{padding:11px 16px;display:flex;align-items:center;gap:10px;font-size:13px;color:var(--text-muted);cursor:pointer;transition:background 0.2s}
.search-suggestion:hover{background:rgba(232,255,71,0.06);color:var(--text-primary)}
.header-actions{display:flex;align-items:center;gap:8px;margin-left:auto}
.btn-icon{width:40px;height:40px;border-radius:50%;background:transparent;border:1px solid var(--border);color:var(--text-muted);display:flex;align-items:center;justify-content:center;cursor:pointer;text-decoration:none;font-size:15px;transition:all 0.25s var(--transition);position:relative}
.btn-icon:hover{background:rgba(232,255,71,0.08);border-color:var(--accent-1);color:var(--accent-1);transform:scale(1.08)}
.badge{position:absolute;top:-2px;right:-2px;width:16px;height:16px;background:var(--accent-2);border-radius:50%;font-size:9px;font-weight:700;color:#fff;display:flex;align-items:center;justify-content:center;border:2px solid var(--bg-primary);animation:ping 2s ease-in-out infinite}
.user-menu{position:relative}
.user-avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--accent-2),var(--accent-1));border:2px solid transparent;cursor:pointer;display:flex;align-items:center;justify-content:center;font-family:'Space Mono',monospace;font-size:13px;font-weight:700;color:var(--bg-primary);transition:all 0.3s var(--transition);text-decoration:none}
.user-avatar:hover{border-color:var(--accent-1);transform:scale(1.08);box-shadow:0 0 0 4px rgba(232,255,71,0.15)}
.user-dropdown{position:absolute;top:calc(100% + 12px);right:0;width:220px;background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius-md);box-shadow:var(--shadow-card);overflow:hidden;opacity:0;transform:translateY(-10px) scale(0.97);pointer-events:none;transition:all 0.28s var(--transition);z-index:300}
.user-menu:hover .user-dropdown,.user-menu:focus-within .user-dropdown{opacity:1;transform:translateY(0) scale(1);pointer-events:auto}
.dropdown-header{padding:16px;border-bottom:1px solid var(--border)}
.dropdown-name{font-weight:500;font-size:14px;color:var(--text-primary)}
.dropdown-email{font-size:12px;color:var(--text-muted);margin-top:2px}
.dropdown-item{display:flex;align-items:center;gap:10px;padding:11px 16px;text-decoration:none;font-size:13px;color:var(--text-muted);transition:all 0.2s}
.dropdown-item:hover{background:rgba(232,255,71,0.06);color:var(--text-primary)}
.dropdown-item i{width:16px}
.dropdown-divider{border:none;border-top:1px solid var(--border);margin:4px 0}
.dropdown-item.danger:hover{background:rgba(255,60,110,0.08);color:var(--accent-2)}
.btn-auth{height:38px;padding:0 18px;border-radius:100px;font-family:'DM Sans',sans-serif;font-size:13px;font-weight:500;cursor:pointer;text-decoration:none;display:flex;align-items:center;gap:6px;transition:all 0.25s var(--transition)}
.btn-login{background:transparent;border:1px solid var(--border);color:var(--text-muted)}
.btn-login:hover{border-color:var(--text-muted);color:var(--text-primary)}
.btn-register{background:var(--accent-1);border:1px solid var(--accent-1);color:var(--bg-primary);font-weight:600}
.btn-register:hover{transform:translateY(-2px);box-shadow:0 6px 24px rgba(232,255,71,0.35)}
.now-playing-bar{display:flex;align-items:center;gap:10px;padding:0 16px;height:100%;border-left:1px solid var(--border);min-width:200px;max-width:240px}
.np-thumb{width:36px;height:36px;border-radius:var(--radius-sm);background:linear-gradient(135deg,#333,#555);flex-shrink:0;overflow:hidden;position:relative}
.np-thumb img{width:100%;height:100%;object-fit:cover}
.np-info{flex:1;min-width:0}
.np-title{font-size:12px;font-weight:500;color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.np-artist{font-size:11px;color:var(--text-muted);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.np-toggle{width:28px;height:28px;border-radius:50%;background:var(--accent-1);border:none;color:var(--bg-primary);font-size:10px;display:flex;align-items:center;justify-content:center;cursor:pointer;flex-shrink:0;transition:all 0.2s}
.np-toggle:hover{transform:scale(1.1)}
.hamburger{display:none;flex-direction:column;gap:5px;cursor:pointer;padding:8px;border-radius:var(--radius-sm);border:none;background:transparent;transition:background 0.2s}
.hamburger:hover{background:rgba(255,255,255,0.05)}
.hamburger span{width:22px;height:2px;background:var(--text-muted);border-radius:2px;transition:all 0.3s var(--transition);display:block}
.hamburger.active span:nth-child(1){transform:rotate(45deg) translate(5px,5px);background:var(--accent-1)}
.hamburger.active span:nth-child(2){opacity:0;transform:scaleX(0)}
.hamburger.active span:nth-child(3){transform:rotate(-45deg) translate(5px,-5px);background:var(--accent-1)}

/* ================================================================
   LAYOUT
================================================================ */
.layout-wrapper{display:flex;padding-top:var(--header-h);min-height:100vh}
.main-content{flex:1;margin-left:var(--sidebar-w);min-height:calc(100vh - var(--header-h));padding:0;transition:margin-left 0.4s var(--transition)}

/* ================================================================
   SIDEBAR
================================================================ */
.sidebar{position:fixed;top:var(--header-h);left:0;width:var(--sidebar-w);height:calc(100vh - var(--header-h));background:var(--bg-secondary);border-right:1px solid var(--border);display:flex;flex-direction:column;overflow-y:auto;overflow-x:hidden;z-index:900;transition:transform 0.4s var(--transition),width 0.4s var(--transition);animation:fadeInLeft 0.5s var(--transition) 0.2s both}
.sidebar.collapsed{width:68px}
.sidebar.collapsed .nav-label,.sidebar.collapsed .section-title,.sidebar.collapsed .mini-player-section,.sidebar.collapsed .playlist-item-meta,.sidebar.collapsed .sidebar-footer-text{opacity:0;pointer-events:none;width:0;overflow:hidden}
.sidebar.collapsed .nav-item{justify-content:center;padding:12px 0}
.sidebar-toggle{position:absolute;top:16px;right:-14px;width:28px;height:28px;background:var(--bg-card);border:1px solid var(--border);border-radius:50%;cursor:pointer;display:flex;align-items:center;justify-content:center;font-size:11px;color:var(--text-muted);transition:all 0.25s var(--transition);z-index:10}
.sidebar-toggle:hover{background:var(--accent-1);border-color:var(--accent-1);color:var(--bg-primary)}
.sidebar-toggle i{transition:transform 0.35s var(--transition)}
.sidebar.collapsed .sidebar-toggle i{transform:rotate(180deg)}
.section-title{font-family:'Space Mono',monospace;font-size:9px;letter-spacing:2px;text-transform:uppercase;color:var(--text-dim);padding:20px 20px 8px;transition:all 0.3s}
.nav-group{padding:0 10px}
.nav-item{display:flex;align-items:center;gap:12px;padding:10px 12px;border-radius:var(--radius-sm);text-decoration:none;font-size:14px;font-weight:400;color:var(--text-muted);cursor:pointer;position:relative;transition:all 0.22s var(--transition);white-space:nowrap}
.nav-item:hover{background:rgba(255,255,255,0.04);color:var(--text-primary)}
.nav-item.active{background:rgba(232,255,71,0.08);color:var(--accent-1)}
.nav-item.active::before{content:'';position:absolute;left:0;top:50%;transform:translateY(-50%);width:3px;height:60%;background:var(--accent-1);border-radius:0 3px 3px 0}
.nav-icon{width:36px;height:36px;border-radius:var(--radius-sm);display:flex;align-items:center;justify-content:center;font-size:15px;flex-shrink:0;transition:all 0.25s var(--transition);background:rgba(255,255,255,0.04)}
.nav-item:hover .nav-icon{background:rgba(232,255,71,0.08);color:var(--accent-1)}
.nav-item.active .nav-icon{background:rgba(232,255,71,0.12);color:var(--accent-1)}
.nav-label{flex:1;transition:all 0.3s}
.nav-badge{background:var(--accent-2);color:#fff;font-size:10px;font-weight:700;padding:2px 6px;border-radius:100px;flex-shrink:0}
.sidebar-divider{border:none;border-top:1px solid var(--border);margin:8px 16px}
.playlist-section{flex:1;overflow-y:auto;overflow-x:hidden}
.playlist-section::-webkit-scrollbar{width:3px}
.playlist-section::-webkit-scrollbar-thumb{background:var(--text-dim)}
.playlist-header{display:flex;align-items:center;justify-content:space-between;padding:8px 20px}
.playlist-add-btn{width:24px;height:24px;border-radius:50%;background:rgba(255,255,255,0.06);border:none;color:var(--text-muted);font-size:12px;display:flex;align-items:center;justify-content:center;cursor:pointer;transition:all 0.2s}
.playlist-add-btn:hover{background:var(--accent-1);color:var(--bg-primary)}
.playlist-list{padding:0 10px}
.playlist-item{display:flex;align-items:center;gap:10px;padding:8px 12px;border-radius:var(--radius-sm);text-decoration:none;cursor:pointer;transition:all 0.2s;animation:fadeSlideIn 0.4s var(--transition) both}
.playlist-item:hover{background:rgba(255,255,255,0.04)}
.playlist-thumb{width:38px;height:38px;border-radius:var(--radius-sm);flex-shrink:0;overflow:hidden;background:var(--bg-card);display:flex;align-items:center;justify-content:center;font-size:16px;transition:transform 0.3s}
.playlist-item:hover .playlist-thumb{transform:scale(1.05)}
.playlist-item-meta{flex:1;min-width:0;transition:all 0.3s}
.playlist-name{font-size:13px;font-weight:500;color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.playlist-count{font-size:11px;color:var(--text-muted);margin-top:1px}
.mini-player-section{padding:12px 16px;border-top:1px solid var(--border);background:var(--bg-primary);transition:all 0.3s}
.mini-player-label{font-size:10px;color:var(--text-dim);letter-spacing:1px;text-transform:uppercase;font-family:'Space Mono',monospace;margin-bottom:10px}
.mini-player-track{display:flex;align-items:center;gap:10px;margin-bottom:12px}
.mini-player-art{width:42px;height:42px;border-radius:var(--radius-sm);overflow:hidden;flex-shrink:0;background:linear-gradient(135deg,var(--accent-1),var(--accent-3));display:flex;align-items:center;justify-content:center;font-size:18px;color:var(--bg-primary)}
.mini-player-info{flex:1;min-width:0}
.mini-player-title{font-size:13px;font-weight:500;color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.mini-player-artist{font-size:11px;color:var(--text-muted)}
.mini-progress-wrap{position:relative;height:3px;background:rgba(255,255,255,0.08);border-radius:3px;margin-bottom:10px;cursor:pointer}
.mini-progress-fill{height:100%;width:0%;background:linear-gradient(90deg,var(--accent-3),var(--accent-1));border-radius:3px;position:relative;transition:width 0.5s linear}
.mini-progress-fill::after{content:'';position:absolute;right:-4px;top:-3px;width:9px;height:9px;background:var(--accent-1);border-radius:50%;opacity:0;transition:opacity 0.2s}
.mini-progress-wrap:hover .mini-progress-fill::after{opacity:1}
.mini-controls{display:flex;align-items:center;justify-content:space-between}
.mini-ctrl-btn{background:none;border:none;color:var(--text-muted);font-size:13px;cursor:pointer;padding:4px;border-radius:4px;transition:all 0.2s}
.mini-ctrl-btn:hover{color:var(--text-primary)}
.mini-ctrl-btn.play-btn{width:32px;height:32px;border-radius:50%;background:var(--accent-1);color:var(--bg-primary);display:flex;align-items:center;justify-content:center;font-size:12px}
.mini-ctrl-btn.play-btn:hover{transform:scale(1.08);box-shadow:0 4px 16px rgba(232,255,71,0.4)}
.mini-volume{display:flex;align-items:center;gap:6px;margin-top:8px}
.mini-volume i{color:var(--text-muted);font-size:11px}
.volume-slider{flex:1;-webkit-appearance:none;appearance:none;height:3px;background:rgba(255,255,255,0.1);border-radius:3px;outline:none;cursor:pointer}
.volume-slider::-webkit-slider-thumb{-webkit-appearance:none;width:10px;height:10px;border-radius:50%;background:var(--accent-1);cursor:pointer}
.sidebar-footer{padding:12px 20px;border-top:1px solid var(--border)}
.sidebar-footer-text{font-size:11px;color:var(--text-dim);line-height:1.6;transition:all 0.3s}
.sidebar-footer-text a{color:var(--accent-1);text-decoration:none}

/* ================================================================
   GENRE NAVBAR
================================================================ */
.genre-navbar{display:flex;align-items:center;background:var(--bg-secondary);border-bottom:1px solid var(--border);padding:0 8px;position:sticky;top:var(--header-h);z-index:800;overflow-x:auto;scrollbar-width:none;-ms-overflow-style:none;animation:navbarSlide 0.5s var(--transition) 0.15s both}
.genre-navbar::-webkit-scrollbar{display:none}
.genre-tab{display:flex;align-items:center;gap:7px;padding:0 16px;height:48px;font-size:13px;font-weight:500;color:var(--text-muted);cursor:pointer;white-space:nowrap;border:none;background:transparent;text-decoration:none;position:relative;border-bottom:2px solid transparent;transition:all 0.22s var(--transition);font-family:'DM Sans',sans-serif}
.genre-tab::after{content:'';position:absolute;bottom:-1px;left:50%;right:50%;height:2px;background:var(--accent-1);border-radius:2px 2px 0 0;transition:all 0.3s var(--transition)}
.genre-tab:hover{color:var(--text-primary)}
.genre-tab:hover::after{left:10%;right:10%}
.genre-tab.active{color:var(--accent-1)}
.genre-tab.active::after{left:0;right:0}
.genre-tab .tab-icon{font-size:14px;transition:transform 0.3s}
.genre-tab:hover .tab-icon,.genre-tab.active .tab-icon{transform:scale(1.2) rotate(-5deg)}
.nav-sep{width:1px;height:20px;background:var(--border);flex-shrink:0;margin:0 4px}
.navbar-actions{display:flex;align-items:center;gap:8px;margin-left:auto;padding-left:16px;flex-shrink:0}
.sort-select{height:32px;padding:0 28px 0 12px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:100px;color:var(--text-muted);font-size:12px;font-family:'DM Sans',sans-serif;cursor:pointer;outline:none;transition:all 0.2s;-webkit-appearance:none;appearance:none;background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 12 8'%3E%3Cpath fill='%237a7a8c' d='M6 8L0 0h12z'/%3E%3C/svg%3E");background-repeat:no-repeat;background-position:right 10px center;background-size:8px}
.sort-select:focus,.sort-select:hover{border-color:var(--accent-1);color:var(--text-primary)}
.view-toggle{display:flex;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:100px;overflow:hidden}
.view-btn{width:32px;height:32px;background:transparent;border:none;color:var(--text-dim);font-size:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.2s}
.view-btn:hover{color:var(--text-primary)}
.view-btn.active{background:rgba(232,255,71,0.1);color:var(--accent-1)}
.breadcrumb-bar{display:flex;align-items:center;gap:6px;padding:12px 32px 0;font-size:13px;color:var(--text-muted);animation:fadeIn 0.4s var(--transition) 0.3s both}
.breadcrumb-bar a{color:var(--text-muted);text-decoration:none;transition:color 0.2s}
.breadcrumb-bar a:hover{color:var(--accent-1)}
.breadcrumb-bar .sep{color:var(--text-dim);font-size:11px}
.breadcrumb-bar .current{color:var(--text-primary);font-weight:500}
.page-title-block{padding:20px 32px 24px;animation:titleReveal 0.6s var(--transition) 0.2s both}
.page-eyebrow{font-family:'Space Mono',monospace;font-size:11px;letter-spacing:2px;text-transform:uppercase;color:var(--accent-1);margin-bottom:8px}
.page-h1{font-family:'Bebas Neue',cursive;font-size:clamp(36px,5vw,64px);letter-spacing:2px;line-height:1;background:linear-gradient(135deg,var(--text-primary) 40%,var(--text-muted));-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent}
.page-subtitle{margin-top:10px;font-size:15px;color:var(--text-muted);max-width:520px}
.filter-chips{display:flex;flex-wrap:wrap;gap:8px;padding:0 32px 16px}
.chip{height:30px;padding:0 14px;border-radius:100px;background:rgba(255,255,255,0.04);border:1px solid var(--border);color:var(--text-muted);font-size:12px;font-family:'DM Sans',sans-serif;cursor:pointer;display:flex;align-items:center;gap:6px;transition:all 0.22s var(--transition);white-space:nowrap}
.chip:hover{border-color:var(--text-muted);color:var(--text-primary);transform:translateY(-1px)}
.chip.active{background:rgba(232,255,71,0.1);border-color:var(--accent-1);color:var(--accent-1)}
.chip .chip-dot{width:6px;height:6px;border-radius:50%;background:currentColor}

/* ================================================================
   MAIN CONTENT AREA
================================================================ */
.content-body{padding:0 32px 32px}

/* ================================================================
   PLAYER BAR
================================================================ */
.player-bar{position:fixed;bottom:0;left:0;right:0;height:80px;background:var(--bg-glass);backdrop-filter:blur(24px) saturate(180%);-webkit-backdrop-filter:blur(24px) saturate(180%);border-top:1px solid var(--border);display:flex;align-items:center;padding:0 20px;gap:16px;z-index:950;animation:playerSlideUp 0.5s var(--transition) 0.4s both}
.player-track{display:flex;align-items:center;gap:12px;min-width:220px;width:28%}
.player-cover{width:52px;height:52px;border-radius:var(--radius-sm);overflow:hidden;flex-shrink:0;background:var(--bg-card);cursor:pointer;position:relative;box-shadow:0 4px 16px rgba(0,0,0,0.5);transition:transform 0.3s var(--transition)}
.player-cover:hover{transform:scale(1.05)}
.player-cover img{width:100%;height:100%;object-fit:cover}
.player-cover-placeholder{width:100%;height:100%;background:linear-gradient(135deg,rgba(232,255,71,0.13),rgba(60,240,197,0.13));display:flex;align-items:center;justify-content:center;font-size:22px;color:var(--accent-1)}
.disc-ring{position:absolute;inset:0;border-radius:50%;border:3px solid transparent;border-top-color:var(--accent-1);animation:spin 1.5s linear infinite;opacity:0;transition:opacity 0.3s}
.player-bar.playing .disc-ring{opacity:0.6}
.player-track-info{flex:1;min-width:0}
.player-title{font-size:14px;font-weight:500;color:var(--text-primary);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;cursor:pointer}
.player-title:hover{color:var(--accent-1)}
.player-artist{font-size:12px;color:var(--text-muted);margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.player-love{background:none;border:none;color:var(--text-dim);font-size:16px;cursor:pointer;padding:4px;transition:all 0.25s;flex-shrink:0}
.player-love:hover,.player-love.loved{color:var(--accent-2);transform:scale(1.2)}
.player-center{flex:1;display:flex;flex-direction:column;align-items:center;gap:8px;max-width:600px}
.player-controls{display:flex;align-items:center;gap:4px}
.ctrl-btn{width:36px;height:36px;border-radius:50%;background:transparent;border:none;color:var(--text-muted);font-size:14px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.22s var(--transition);position:relative}
.ctrl-btn:hover{background:rgba(255,255,255,0.06);color:var(--text-primary);transform:scale(1.08)}
.ctrl-btn.active{color:var(--accent-1)}
.ctrl-btn.active::after{content:'';position:absolute;bottom:3px;left:50%;transform:translateX(-50%);width:4px;height:4px;border-radius:50%;background:var(--accent-1)}
.play-pause-btn{width:44px;height:44px;border-radius:50%;background:var(--accent-1);border:none;color:var(--bg-primary);font-size:16px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.25s var(--transition);box-shadow:0 4px 20px rgba(232,255,71,0.35)}
.play-pause-btn:hover{transform:scale(1.08);box-shadow:0 6px 28px rgba(232,255,71,0.5)}
.play-pause-btn:active{transform:scale(0.95)}
.player-progress{width:100%;display:flex;align-items:center;gap:10px}
.time-label{font-family:'Space Mono',monospace;font-size:11px;color:var(--text-dim);flex-shrink:0;min-width:36px}
.progress-track{flex:1;height:4px;background:rgba(255,255,255,0.1);border-radius:4px;cursor:pointer;position:relative;overflow:visible}
.progress-fill{height:100%;width:0%;background:linear-gradient(90deg,var(--accent-3),var(--accent-1));border-radius:4px;pointer-events:none;position:relative;transition:width 0.3s linear}
.progress-thumb{position:absolute;right:-6px;top:-4px;width:12px;height:12px;border-radius:50%;background:var(--accent-1);opacity:0;transition:opacity 0.2s;box-shadow:0 0 8px rgba(232,255,71,0.6)}
.progress-track:hover .progress-thumb{opacity:1}
.player-right{display:flex;align-items:center;gap:8px;min-width:180px;width:22%;justify-content:flex-end}
.queue-btn{width:32px;height:32px;border-radius:var(--radius-sm);background:transparent;border:none;color:var(--text-muted);font-size:13px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:all 0.2s}
.queue-btn:hover{background:rgba(255,255,255,0.06);color:var(--text-primary)}
.volume-group{display:flex;align-items:center;gap:6px}
.volume-icon{background:none;border:none;color:var(--text-muted);font-size:13px;cursor:pointer;transition:color 0.2s;padding:4px}
.volume-icon:hover{color:var(--text-primary)}
.volume-range{width:88px;-webkit-appearance:none;appearance:none;height:4px;background:rgba(255,255,255,0.12);border-radius:4px;outline:none;cursor:pointer}
.volume-range::-webkit-slider-thumb{-webkit-appearance:none;width:12px;height:12px;border-radius:50%;background:var(--text-primary);cursor:pointer;transition:background 0.2s}
.volume-range::-webkit-slider-thumb:hover{background:var(--accent-1)}

/* ================================================================
   SITE FOOTER
================================================================ */
.site-footer{background:var(--bg-secondary);border-top:1px solid var(--border);padding:48px 40px 100px;animation:fadeIn 0.6s var(--transition) both}
.footer-grid{display:grid;grid-template-columns:2fr 1fr 1fr 1fr;gap:40px;max-width:1200px;margin:0 auto 40px}
.footer-brand .footer-logo{display:flex;align-items:center;gap:10px;text-decoration:none;margin-bottom:16px}
.footer-logo-icon{width:36px;height:36px;background:linear-gradient(135deg,var(--accent-1),var(--accent-3));border-radius:var(--radius-sm);display:flex;align-items:center;justify-content:center;font-size:16px;color:var(--bg-primary)}
.footer-logo-text{font-family:'Bebas Neue',cursive;font-size:22px;letter-spacing:2px;color:var(--text-primary)}
.footer-logo-text span{color:var(--accent-1)}
.footer-tagline{font-size:14px;color:var(--text-muted);line-height:1.7;margin-bottom:20px;max-width:260px}
.footer-socials{display:flex;gap:8px}
.social-btn{width:36px;height:36px;border-radius:50%;background:rgba(255,255,255,0.04);border:1px solid var(--border);color:var(--text-muted);display:flex;align-items:center;justify-content:center;text-decoration:none;font-size:13px;transition:all 0.25s var(--transition)}
.social-btn:hover{transform:translateY(-3px);border-color:var(--accent-1);color:var(--accent-1);background:rgba(232,255,71,0.06)}
.footer-col-title{font-family:'Space Mono',monospace;font-size:10px;letter-spacing:2px;text-transform:uppercase;color:var(--text-primary);margin-bottom:16px}
.footer-links{list-style:none;display:flex;flex-direction:column;gap:10px}
.footer-links a{font-size:13px;color:var(--text-muted);text-decoration:none;transition:all 0.2s;display:flex;align-items:center;gap:6px}
.footer-links a:hover{color:var(--accent-1);transform:translateX(4px)}
.app-download{margin-top:12px;display:flex;flex-direction:column;gap:8px}
.app-btn{display:flex;align-items:center;gap:10px;padding:8px 14px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:var(--radius-sm);text-decoration:none;transition:all 0.25s var(--transition)}
.app-btn:hover{border-color:var(--accent-1);background:rgba(232,255,71,0.04);transform:translateX(4px)}
.app-btn i{font-size:20px;color:var(--text-primary)}
.app-btn-text{line-height:1.3}
.app-btn-sub{font-size:10px;color:var(--text-muted)}
.app-btn-name{font-size:13px;font-weight:500;color:var(--text-primary)}
.footer-bottom{border-top:1px solid var(--border);padding-top:24px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;max-width:1200px;margin:0 auto}
.footer-copy{font-size:12px;color:var(--text-dim)}
.footer-copy a{color:var(--accent-1);text-decoration:none}
.footer-legal{display:flex;gap:16px}
.footer-legal a{font-size:12px;color:var(--text-dim);text-decoration:none;transition:color 0.2s}
.footer-legal a:hover{color:var(--text-muted)}

/* ================================================================
   VALIDATION FORM STYLES
================================================================ */
.form-group{position:relative;display:flex;flex-direction:column;gap:6px;margin-bottom:20px}
.form-label{font-size:13px;font-weight:500;color:var(--text-muted);display:flex;align-items:center;gap:4px}
.form-label .required-star{color:var(--accent-2)}
.form-input{width:100%;height:46px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:10px;padding:0 40px 0 14px;color:var(--text-primary);font-family:'DM Sans',sans-serif;font-size:14px;outline:none;transition:border-color 0.25s,box-shadow 0.25s,background 0.25s}
.form-input::placeholder{color:var(--text-dim)}
.form-input:focus{border-color:var(--accent-1);background:rgba(232,255,71,0.03);box-shadow:0 0 0 3px rgba(232,255,71,0.08)}
.form-input.field-invalid{border-color:var(--accent-2)!important;box-shadow:0 0 0 3px rgba(255,60,110,0.10)}
.form-input.field-valid{border-color:rgba(60,240,197,0.5)}
.field-status-icon{position:absolute;right:12px;bottom:13px;font-size:15px;pointer-events:none}
.field-error{font-size:12px;color:var(--accent-2);display:none;align-items:center;gap:5px}
.btn-submit{width:100%;height:48px;border-radius:100px;background:var(--accent-1);border:none;color:var(--bg-primary);font-family:'DM Sans',sans-serif;font-size:15px;font-weight:600;cursor:pointer;transition:all 0.3s var(--transition);display:flex;align-items:center;justify-content:center;gap:8px;letter-spacing:0.3px}
.btn-submit:hover:not(:disabled){transform:translateY(-2px);box-shadow:0 8px 28px rgba(232,255,71,0.4)}
.btn-submit:disabled{opacity:0.5;cursor:not-allowed;transform:none}
.btn-submit.loading{pointer-events:none;background:rgba(232,255,71,0.6)}
.btn-submit .btn-spinner{width:16px;height:16px;border:2px solid rgba(10,10,15,0.3);border-top-color:var(--bg-primary);border-radius:50%;animation:spin 0.7s linear infinite}
.password-strength{height:4px;background:rgba(255,255,255,0.08);border-radius:4px;overflow:hidden;margin-top:2px}
.password-strength-fill{height:100%;border-radius:4px;transition:width 0.4s,background 0.4s}
.strength-label{font-size:11px;color:var(--text-dim);margin-top:2px}
.char-counter{font-size:11px;color:var(--text-dim);text-align:right}
.char-counter.over{color:var(--accent-2)}
.password-toggle{position:absolute;right:12px;bottom:12px;background:none;border:none;color:var(--text-dim);cursor:pointer;font-size:14px;padding:2px;transition:color 0.2s}
.password-toggle:hover{color:var(--text-muted)}

/* ================================================================
   RESPONSIVE
================================================================ */
@media(max-width:900px){
  .now-playing-bar{display:none}
  .header-search{max-width:300px}
  .footer-grid{grid-template-columns:1fr 1fr}
  .site-footer{padding:32px 24px 100px}
}
@media(max-width:640px){
  .hamburger{display:flex}
  .header-search{display:none}
  .main-content{margin-left:0!important}
  .sidebar{transform:translateX(-100%)}
  .sidebar.mobile-open{transform:translateX(0)}
  .player-track{min-width:0;width:auto}
  .player-right{display:none}
  .time-label{display:none}
  .footer-grid{grid-template-columns:1fr;gap:28px}
  .content-body,.filter-chips,.breadcrumb-bar,.page-title-block{padding-left:16px;padding-right:16px}
}
</style>
</head>
<body>

<!-- ============================================================
     HEADER
============================================================ -->
<header class="site-header" id="siteHeader">
  <button class="hamburger" id="hamburger" aria-label="Menu" onclick="toggleSidebar()">
    <span></span><span></span><span></span>
  </button>
  <a href="${pageContext.request.contextPath}/" class="header-logo">
    <div class="logo-icon"><i class="fas fa-music"></i></div>
    <span class="logo-text">Mu<span>Li</span></span>
  </a>
  <div class="header-search">
    <input type="text" id="globalSearch" placeholder="Tìm kiếm bài hát, nghệ sĩ, album..." autocomplete="off">
    <i class="fas fa-search search-icon"></i>
    <div class="search-dropdown" id="searchDropdown">
      <div class="search-suggestion"><i class="fas fa-fire-flame-curved" style="color:var(--accent-2)"></i> Trending: Sơn Tùng MTP</div>
      <div class="search-suggestion"><i class="fas fa-clock" style="color:var(--accent-3)"></i> Lịch sử: Chill Playlist</div>
      <div class="search-suggestion"><i class="fas fa-magnifying-glass"></i> Tìm "nhạc trẻ 2024"</div>
    </div>
  </div>
  <div class="header-actions">
    <div class="now-playing-bar">
      <div class="np-thumb">
        <img src="https://via.placeholder.com/36x36/e8ff47/0a0a0f?text=♪" alt="cover">
      </div>
      <div class="np-info">
        <div class="np-title" id="npBarTitle">Chưa phát gì</div>
        <div class="np-artist" id="npBarArtist">--</div>
      </div>
      <button class="np-toggle" onclick="togglePlay()">
        <i class="fas fa-play" id="npIcon"></i>
      </button>
    </div>
    <a href="#" class="btn-icon" title="Thông báo"><i class="fas fa-bell"></i><span class="badge">3</span></a>
    <a href="${pageContext.request.contextPath}/favorites" class="btn-icon" title="Yêu thích"><i class="fas fa-heart"></i></a>
    <c:choose>
      <c:when test="${not empty sessionScope.user}">
        <div class="user-menu">
          <a href="#" class="user-avatar">${sessionScope.user.initials}</a>
          <div class="user-dropdown">
            <div class="dropdown-header">
              <div class="dropdown-name">${sessionScope.user.fullName}</div>
              <div class="dropdown-email">${sessionScope.user.email}</div>
            </div>
            <a href="${pageContext.request.contextPath}/profile"     class="dropdown-item"><i class="fas fa-user"></i> Hồ sơ của tôi</a>
            <a href="${pageContext.request.contextPath}/my-playlists" class="dropdown-item"><i class="fas fa-list-music"></i> Playlist của tôi</a>
            <a href="${pageContext.request.contextPath}/history"      class="dropdown-item"><i class="fas fa-clock-rotate-left"></i> Lịch sử nghe</a>
            <a href="${pageContext.request.contextPath}/settings"     class="dropdown-item"><i class="fas fa-gear"></i> Cài đặt</a>
            <hr class="dropdown-divider">
            <a href="${pageContext.request.contextPath}/logout"       class="dropdown-item danger"><i class="fas fa-right-from-bracket"></i> Đăng xuất</a>
          </div>
        </div>
      </c:when>
      <c:otherwise>
        <a href="${pageContext.request.contextPath}/login"    class="btn-auth btn-login"><i class="fas fa-right-to-bracket"></i> Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/register" class="btn-auth btn-register"><i class="fas fa-user-plus"></i> Đăng ký</a>
      </c:otherwise>
    </c:choose>
  </div>
</header>

<!-- ============================================================
     LAYOUT WRAPPER
============================================================ -->
<div class="layout-wrapper">

  <!-- SIDEBAR -->
  <aside class="sidebar" id="sidebar">
    <button class="sidebar-toggle" onclick="toggleCollapse()" title="Thu/mở sidebar">
      <i class="fas fa-chevron-left" id="collapseIcon"></i>
    </button>
    <nav class="nav-group" style="padding-top:16px">
      <p class="section-title">Khám phá</p>
      <a href="${pageContext.request.contextPath}/"              class="nav-item active"><span class="nav-icon"><i class="fas fa-house"></i></span><span class="nav-label">Trang chủ</span></a>
      <a href="${pageContext.request.contextPath}/discover"      class="nav-item"><span class="nav-icon"><i class="fas fa-compass"></i></span><span class="nav-label">Khám phá</span></a>
      <a href="${pageContext.request.contextPath}/trending"      class="nav-item"><span class="nav-icon"><i class="fas fa-fire"></i></span><span class="nav-label">Trending</span><span class="nav-badge">Hot</span></a>
      <a href="${pageContext.request.contextPath}/new-releases"  class="nav-item"><span class="nav-icon"><i class="fas fa-star"></i></span><span class="nav-label">Mới phát hành</span></a>
      <a href="${pageContext.request.contextPath}/genres"        class="nav-item"><span class="nav-icon"><i class="fas fa-layer-group"></i></span><span class="nav-label">Thể loại</span></a>
    </nav>
    <hr class="sidebar-divider">
    <nav class="nav-group">
      <p class="section-title">Thư Viện</p>
      <a href="${pageContext.request.contextPath}/favorites"  class="nav-item"><span class="nav-icon"><i class="fas fa-heart"></i></span><span class="nav-label">Yêu thích</span></a>
      <a href="${pageContext.request.contextPath}/albums"     class="nav-item"><span class="nav-icon"><i class="fas fa-record-vinyl"></i></span><span class="nav-label">Albums</span></a>
      <a href="${pageContext.request.contextPath}/artists"    class="nav-item"><span class="nav-icon"><i class="fas fa-microphone"></i></span><span class="nav-label">Nghệ sĩ</span></a>
      <a href="${pageContext.request.contextPath}/history"    class="nav-item"><span class="nav-icon"><i class="fas fa-clock-rotate-left"></i></span><span class="nav-label">Lịch sử</span></a>
      <a href="${pageContext.request.contextPath}/downloads"  class="nav-item"><span class="nav-icon"><i class="fas fa-download"></i></span><span class="nav-label">Đã tải</span></a>
    </nav>
    <hr class="sidebar-divider">
    <div class="playlist-section">
      <div class="playlist-header">
        <p class="section-title" style="padding:0;margin:0">Playlist của tôi</p>
        <button class="playlist-add-btn" onclick="createPlaylist()" title="Tạo mới"><i class="fas fa-plus"></i></button>
      </div>
      <div class="playlist-list">
        <c:choose>
          <c:when test="${not empty sessionScope.playlists}">
            <c:forEach var="pl" items="${sessionScope.playlists}" varStatus="st">
              <a href="${pageContext.request.contextPath}/playlist/${pl.id}" class="playlist-item" style="animation-delay:${st.index*60}ms">
                <div class="playlist-thumb">${pl.emoji}</div>
                <div class="playlist-item-meta"><div class="playlist-name">${pl.name}</div><div class="playlist-count">${pl.songCount} bài hát</div></div>
              </a>
            </c:forEach>
          </c:when>
          <c:otherwise>
            <a href="#" class="playlist-item" style="animation-delay:0ms"><div class="playlist-thumb">🎵</div><div class="playlist-item-meta"><div class="playlist-name">Chill Vibes</div><div class="playlist-count">24 bài hát</div></div></a>
            <a href="#" class="playlist-item" style="animation-delay:60ms"><div class="playlist-thumb">🔥</div><div class="playlist-item-meta"><div class="playlist-name">Workout Mix</div><div class="playlist-count">18 bài hát</div></div></a>
            <a href="#" class="playlist-item" style="animation-delay:120ms"><div class="playlist-thumb">🌙</div><div class="playlist-item-meta"><div class="playlist-name">Đêm khuya</div><div class="playlist-count">31 bài hát</div></div></a>
            <a href="#" class="playlist-item" style="animation-delay:180ms"><div class="playlist-thumb">💔</div><div class="playlist-item-meta"><div class="playlist-name">Buồn</div><div class="playlist-count">12 bài hát</div></div></a>
            <a href="#" class="playlist-item" style="animation-delay:240ms"><div class="playlist-thumb">🎶</div><div class="playlist-item-meta"><div class="playlist-name">V-Pop Hits</div><div class="playlist-count">47 bài hát</div></div></a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
    <div class="mini-player-section">
      <div class="mini-player-label">Đang phát</div>
      <div class="mini-player-track">
        <div class="mini-player-art"><i class="fas fa-music"></i></div>
        <div class="mini-player-info">
          <div class="mini-player-title" id="sidebarTitle">Chưa phát</div>
          <div class="mini-player-artist" id="sidebarArtist">--</div>
        </div>
      </div>
      <div class="mini-progress-wrap" onclick="seekTo(event)">
        <div class="mini-progress-fill" id="miniProgress"></div>
      </div>
      <div class="mini-controls">
        <button class="mini-ctrl-btn" onclick="prevTrack()"><i class="fas fa-backward-step"></i></button>
        <button class="mini-ctrl-btn" onclick="shuffleToggle()" id="shuffleBtn"><i class="fas fa-shuffle"></i></button>
        <button class="mini-ctrl-btn play-btn" onclick="togglePlay()" id="sidebarPlayBtn"><i class="fas fa-play" id="sidebarPlayIcon"></i></button>
        <button class="mini-ctrl-btn" onclick="repeatToggle()" id="repeatBtn"><i class="fas fa-repeat"></i></button>
        <button class="mini-ctrl-btn" onclick="nextTrack()"><i class="fas fa-forward-step"></i></button>
      </div>
      <div class="mini-volume">
        <i class="fas fa-volume-low"></i>
        <input type="range" class="volume-slider" id="volumeSlider" min="0" max="100" value="80" oninput="setVolume(this.value)">
        <i class="fas fa-volume-high"></i>
      </div>
    </div>
    <div class="sidebar-footer">
      <div class="sidebar-footer-text">&copy; 2024 <a href="#">Muli</a><br><a href="#">Điều khoản</a> · <a href="#">Riêng tư</a></div>
    </div>
  </aside>

  <!-- MAIN CONTENT -->
  <div class="main-content" id="mainContent">

    <!-- NAVBAR: Genre tabs -->
    <nav class="genre-navbar" id="genreNavbar" role="navigation" aria-label="Thể loại">
      <a href="${pageContext.request.contextPath}/"                class="genre-tab active" data-genre="all"><span class="tab-icon">✦</span> Tất cả</a>
      <a href="${pageContext.request.contextPath}/genre/vpop"      class="genre-tab" data-genre="vpop"><span class="tab-icon">🇻🇳</span> V-Pop</a>
      <a href="${pageContext.request.contextPath}/genre/pop"       class="genre-tab" data-genre="pop"><span class="tab-icon">🎤</span> Pop</a>
      <a href="${pageContext.request.contextPath}/genre/rap"       class="genre-tab" data-genre="rap"><span class="tab-icon">🎧</span> Rap / Hip-hop</a>
      <a href="${pageContext.request.contextPath}/genre/rnb"       class="genre-tab" data-genre="rnb"><span class="tab-icon">🎷</span> R&amp;B / Soul</a>
      <a href="${pageContext.request.contextPath}/genre/edm"       class="genre-tab" data-genre="edm"><span class="tab-icon">⚡</span> EDM / Dance</a>
      <a href="${pageContext.request.contextPath}/genre/balad"     class="genre-tab" data-genre="balad"><span class="tab-icon">🌙</span> Ballad</a>
      <a href="${pageContext.request.contextPath}/genre/indie"     class="genre-tab" data-genre="indie"><span class="tab-icon">🎸</span> Indie</a>
      <a href="${pageContext.request.contextPath}/genre/lofi"      class="genre-tab" data-genre="lofi"><span class="tab-icon">☕</span> Lo-fi / Chill</a>
      <a href="${pageContext.request.contextPath}/genre/classical" class="genre-tab" data-genre="classical"><span class="tab-icon">🎻</span> Cổ điển</a>
      <div class="nav-sep"></div>
      <div class="navbar-actions">
        <select class="sort-select" onchange="handleSort(this.value)" aria-label="Sắp xếp">
          <option value="popular">Phổ biến nhất</option>
          <option value="newest">Mới nhất</option>
          <option value="oldest">Cũ nhất</option>
          <option value="name">Tên A-Z</option>
          <option value="artist">Nghệ sĩ</option>
        </select>
        <div class="view-toggle" role="group" aria-label="Chế độ hiển thị">
          <button class="view-btn active" onclick="setView('grid',this)" title="Lưới"><i class="fas fa-grid-2"></i></button>
          <button class="view-btn" onclick="setView('list',this)" title="Danh sách"><i class="fas fa-list"></i></button>
        </div>
      </div>
    </nav>

    <!-- Page title + filter chips -->
    <div class="page-title-block">
      <p class="page-eyebrow">Thư Viện Âm Nhạc</p>
      <h1 class="page-h1"><c:out value="${pageTitle}" default="Khám Phá"/></h1>
      <p class="page-subtitle">Hàng triệu bài hát. Nghe bất cứ lúc nào, bất cứ nơi đâu.</p>
    </div>

    <div class="filter-chips">
      <button class="chip active" onclick="toggleChip(this,'mood','all')"><span class="chip-dot"></span> Tất cả</button>
      <button class="chip" onclick="toggleChip(this,'mood','happy')">😄 Vui</button>
      <button class="chip" onclick="toggleChip(this,'mood','sad')">😢 Buồn</button>
      <button class="chip" onclick="toggleChip(this,'mood','chill')">😌 Chill</button>
      <button class="chip" onclick="toggleChip(this,'mood','energy')">⚡ Năng lượng</button>
      <button class="chip" onclick="toggleChip(this,'mood','romantic')">💕 Lãng mạn</button>
      <button class="chip" onclick="toggleChip(this,'mood','focus')">🧘 Tập trung</button>
    </div>

    <!-- ======================================================
         MAIN PAGE CONTENT — JSP pages include this layout
         and put their body content in .content-body below
    ====================================================== -->
    <div class="content-body" id="mainGrid">
      <jsp:include page="${pageContext.request.contextPath}/WEB-INF/jsp/${currentPage}.jsp" />
    </div>

  </div><!-- /main-content -->
</div><!-- /layout-wrapper -->

<!-- ============================================================
     FIXED AUDIO PLAYER BAR
============================================================ -->
<div class="player-bar" id="playerBar">
  <div class="player-track">
    <div class="player-cover" id="playerCoverWrap">
      <div class="player-cover-placeholder" id="playerCoverPlaceholder"><i class="fas fa-music"></i></div>
      <img id="playerCoverImg" src="" alt="cover" style="display:none">
      <div class="disc-ring" id="discRing"></div>
    </div>
    <div class="player-track-info">
      <div class="player-title" id="playerTitle">Chọn bài hát để phát</div>
      <div class="player-artist" id="playerArtist">Muli</div>
    </div>
    <button class="player-love" id="loveBtn" onclick="toggleLove()" title="Yêu thích"><i class="fas fa-heart"></i></button>
  </div>
  <div class="player-center">
    <div class="player-controls">
      <button class="ctrl-btn" id="shuffleBtn2" onclick="shuffleToggle()" title="Ngẫu nhiên"><i class="fas fa-shuffle"></i></button>
      <button class="ctrl-btn" onclick="prevTrack()" title="Trước"><i class="fas fa-backward-step"></i></button>
      <button class="play-pause-btn" id="mainPlayBtn" onclick="togglePlay()"><i class="fas fa-play" id="mainPlayIcon"></i></button>
      <button class="ctrl-btn" onclick="nextTrack()" title="Tiếp theo"><i class="fas fa-forward-step"></i></button>
      <button class="ctrl-btn" id="repeatBtn2" onclick="repeatToggle()" title="Lặp lại"><i class="fas fa-repeat"></i></button>
    </div>
    <div class="player-progress">
      <span class="time-label" id="currentTime">0:00</span>
      <div class="progress-track" id="progressTrack" onclick="playerSeek(event)">
        <div class="progress-fill" id="progressFill"><div class="progress-thumb"></div></div>
      </div>
      <span class="time-label" id="totalTime">0:00</span>
    </div>
  </div>
  <div class="player-right">
    <button class="queue-btn" onclick="toggleQueue()" title="Hàng đợi"><i class="fas fa-list-music"></i></button>
    <button class="queue-btn" title="Lyrics"><i class="fas fa-microphone-lines"></i></button>
    <div class="volume-group">
      <button class="volume-icon" onclick="toggleMute()" id="volIcon"><i class="fas fa-volume-high" id="volIconI"></i></button>
      <input type="range" class="volume-range" id="mainVolume" min="0" max="100" value="80" oninput="setVolume(this.value)">
    </div>
  </div>
</div>

<!-- ============================================================
     SITE FOOTER
============================================================ -->
<footer class="site-footer">
  <div class="footer-grid">
    <div class="footer-brand">
      <a href="${pageContext.request.contextPath}/" class="footer-logo">
        <div class="footer-logo-icon"><i class="fas fa-music"></i></div>
        <span class="footer-logo-text">Mu<span>Li</span></span>
      </a>
      <p class="footer-tagline">Nơi mọi giai điệu tìm thấy ngôi nhà của mình. Khám phá, nghe và chia sẻ âm nhạc tuyệt vời.</p>
      <div class="footer-socials">
        <a href="#" class="social-btn"><i class="fab fa-facebook-f"></i></a>
        <a href="#" class="social-btn"><i class="fab fa-instagram"></i></a>
        <a href="#" class="social-btn"><i class="fab fa-tiktok"></i></a>
        <a href="#" class="social-btn"><i class="fab fa-youtube"></i></a>
        <a href="#" class="social-btn"><i class="fab fa-spotify"></i></a>
      </div>
    </div>
    <div>
      <h4 class="footer-col-title">Khám phá</h4>
      <ul class="footer-links">
        <li><a href="${pageContext.request.contextPath}/trending"><i class="fas fa-fire fa-fw"></i> Trending</a></li>
        <li><a href="${pageContext.request.contextPath}/new-releases"><i class="fas fa-star fa-fw"></i> Mới phát hành</a></li>
        <li><a href="${pageContext.request.contextPath}/genres"><i class="fas fa-layer-group fa-fw"></i> Thể loại</a></li>
        <li><a href="${pageContext.request.contextPath}/artists"><i class="fas fa-microphone fa-fw"></i> Nghệ sĩ</a></li>
        <li><a href="${pageContext.request.contextPath}/albums"><i class="fas fa-record-vinyl fa-fw"></i> Albums</a></li>
        <li><a href="${pageContext.request.contextPath}/charts"><i class="fas fa-chart-simple fa-fw"></i> Bảng xếp hạng</a></li>
      </ul>
    </div>
    <div>
      <h4 class="footer-col-title">Hỗ trợ</h4>
      <ul class="footer-links">
        <li><a href="${pageContext.request.contextPath}/help"><i class="fas fa-circle-question fa-fw"></i> Trung tâm hỗ trợ</a></li>
        <li><a href="${pageContext.request.contextPath}/contact"><i class="fas fa-envelope fa-fw"></i> Liên hệ</a></li>
        <li><a href="${pageContext.request.contextPath}/faq"><i class="fas fa-comments fa-fw"></i> FAQ</a></li>
        <li><a href="${pageContext.request.contextPath}/about"><i class="fas fa-info-circle fa-fw"></i> Về chúng tôi</a></li>
        <li><a href="${pageContext.request.contextPath}/premium"><i class="fas fa-crown fa-fw"></i> Premium</a></li>
      </ul>
    </div>
    <div>
      <h4 class="footer-col-title">Tải ứng dụng</h4>
      <div class="app-download">
        <a href="#" class="app-btn"><i class="fab fa-apple"></i><div class="app-btn-text"><div class="app-btn-sub">Tải về từ</div><div class="app-btn-name">App Store</div></div></a>
        <a href="#" class="app-btn"><i class="fab fa-google-play"></i><div class="app-btn-text"><div class="app-btn-sub">Tải về từ</div><div class="app-btn-name">Google Play</div></div></a>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <p class="footer-copy">&copy; 2024 <a href="#">Muli</a>. Bảo lưu mọi quyền. Âm nhạc thuộc quyền sở hữu của các nghệ sĩ tương ứng.</p>
    <nav class="footer-legal">
      <a href="${pageContext.request.contextPath}/terms">Điều khoản sử dụng</a>
      <a href="${pageContext.request.contextPath}/privacy">Chính sách riêng tư</a>
      <a href="${pageContext.request.contextPath}/cookies">Cookie</a>
    </nav>
  </div>
</footer>

<!-- ============================================================
     SCRIPTS: validation.js (inline) + player + UI logic
============================================================ -->
<script>
/* ============================================================
   VALIDATION.JS — inline
============================================================ */
'use strict';
const $ = (s,c=document)=>c.querySelector(s);
const $$=(s,c=document)=>[...c.querySelectorAll(s)];

const Toast={
  container:null,
  init(){if(this.container)return;this.container=Object.assign(document.createElement('div'),{id:'toastContainer'});Object.assign(this.container.style,{position:'fixed',bottom:'100px',right:'24px',display:'flex',flexDirection:'column',gap:'10px',zIndex:'9999',pointerEvents:'none'});document.body.appendChild(this.container)},
  show(message,type='info',duration=3500){this.init();const colors={success:{bg:'#e8ff47',color:'#0a0a0f',icon:'fa-circle-check'},error:{bg:'#ff3c6e',color:'#fff',icon:'fa-circle-xmark'},info:{bg:'#3cf0c5',color:'#0a0a0f',icon:'fa-circle-info'},warning:{bg:'#ffb347',color:'#0a0a0f',icon:'fa-triangle-exclamation'}};const cfg=colors[type]||colors.info;const t=document.createElement('div');t.innerHTML=`<i class="fas ${cfg.icon}" style="font-size:14px"></i><span style="font-size:13px;font-family:'DM Sans',sans-serif">${message}</span>`;Object.assign(t.style,{display:'flex',alignItems:'center',gap:'10px',padding:'12px 16px',background:cfg.bg,color:cfg.color,borderRadius:'10px',boxShadow:'0 8px 24px rgba(0,0,0,0.4)',pointerEvents:'auto',transform:'translateX(120%)',transition:'transform 0.4s cubic-bezier(0.23,1,0.32,1),opacity 0.3s',opacity:'0',maxWidth:'320px',fontWeight:'500'});this.container.appendChild(t);requestAnimationFrame(()=>{t.style.transform='translateX(0)';t.style.opacity='1'});setTimeout(()=>{t.style.transform='translateX(120%)';t.style.opacity='0';setTimeout(()=>t.remove(),400)},duration)},
  success:(m,d)=>Toast.show(m,'success',d),
  error:(m,d)=>Toast.show(m,'error',d),
  info:(m,d)=>Toast.show(m,'info',d),
  warning:(m,d)=>Toast.show(m,'warning',d),
};

const Rules={
  required:(v)=>v.trim()!==''||'Trường này là bắt buộc.',
  minLen:(n)=>(v)=>v.length>=n||`Tối thiểu ${n} ký tự.`,
  maxLen:(n)=>(v)=>v.length<=n||`Tối đa ${n} ký tự.`,
  email:(v)=>/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v)||'Email không hợp lệ.',
  phone:(v)=>/^(0|\+84)[3-9]\d{8}$/.test(v.replace(/\s/g,''))||'Số điện thoại không hợp lệ.',
  password:(v)=>/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(v)||'Mật khẩu cần ít nhất 8 ký tự, gồm chữ hoa, thường và số.',
  match:(other)=>(v,form)=>{const ov=form?($(other,form)?.value??''):'';return v===ov||'Mật khẩu xác nhận không khớp.'},
  username:(v)=>/^[a-zA-Z0-9_]{3,20}$/.test(v)||'Username chỉ gồm chữ, số, gạch dưới (3-20 ký tự).',
};

function validateField(field,rules,form=null){
  const value=field.value;let firstError=null;
  for(const rule of rules){const r=rule(value,form);if(r!==true){firstError=r;break}}
  setFieldState(field,firstError);return firstError===null;
}

function setFieldState(field,errorMsg){
  const wrap=field.closest('.form-group')||field.parentElement;
  const errEl=wrap?.querySelector('.field-error');
  const iconEl=wrap?.querySelector('.field-status-icon');
  field.classList.remove('field-valid','field-invalid');
  if(errorMsg){
    field.classList.add('field-invalid');
    if(errEl){errEl.textContent=errorMsg;errEl.style.display='block';errEl.style.animation='errorShake 0.3s ease';setTimeout(()=>errEl.style.animation='',300)}
    if(iconEl)iconEl.innerHTML='<i class="fas fa-circle-xmark" style="color:var(--accent-2)"></i>';
  }else{
    field.classList.add('field-valid');
    if(errEl)errEl.style.display='none';
    if(iconEl)iconEl.innerHTML='<i class="fas fa-circle-check" style="color:var(--accent-3)"></i>';
  }
}

function addPasswordToggle(field){
  if(!field)return;
  const wrap=field.closest('.form-group')||field.parentElement;
  if(!wrap||wrap.querySelector('.password-toggle'))return;
  const btn=document.createElement('button');btn.type='button';btn.className='password-toggle';btn.innerHTML='<i class="fas fa-eye"></i>';btn.setAttribute('aria-label','Hiện/ẩn mật khẩu');
  btn.addEventListener('click',()=>{const isText=field.type==='text';field.type=isText?'password':'text';btn.innerHTML=`<i class="fas fa-eye${isText?'':'-slash'}"></i>`});
  wrap.style.position='relative';wrap.appendChild(btn);
}

function updatePasswordStrength(password,form){
  const meterEl=form.querySelector('.password-strength-fill');const labelEl=form.querySelector('.strength-label');if(!meterEl||!labelEl)return;
  let s=0;if(password.length>=8)s++;if(/[A-Z]/.test(password))s++;if(/[a-z]/.test(password))s++;if(/\d/.test(password))s++;if(/[^A-Za-z0-9]/.test(password))s++;
  const levels=[{width:'0%',color:'transparent',label:''},{width:'20%',color:'#ff3c6e',label:'🔴 Rất yếu'},{width:'40%',color:'#ffb347',label:'🟠 Yếu'},{width:'60%',color:'#ffdd57',label:'🟡 Trung bình'},{width:'80%',color:'#3cf0c5',label:'🟢 Mạnh'},{width:'100%',color:'#e8ff47',label:'⚡ Rất mạnh'}];
  const lvl=levels[s]||levels[0];meterEl.style.width=lvl.width;meterEl.style.background=lvl.color;labelEl.textContent=lvl.label;
}

function addCharCounter(field,max){
  if(!field)return;const wrap=field.closest('.form-group')||field.parentElement;if(!wrap)return;
  const counter=document.createElement('div');counter.className='char-counter';counter.textContent=`0 / ${max}`;wrap.appendChild(counter);
  field.addEventListener('input',()=>{const len=field.value.length;counter.textContent=`${len} / ${max}`;counter.classList.toggle('over',len>max)});
}

function setButtonLoading(btn,isLoading){
  if(!btn)return;
  if(isLoading){btn.dataset.originalText=btn.innerHTML;btn.innerHTML='<div class="btn-spinner"></div> Đang xử lý...';btn.classList.add('loading');btn.disabled=true}
  else{btn.innerHTML=btn.dataset.originalText||'Gửi';btn.classList.remove('loading');btn.disabled=false}
}

function shakeForm(form){form.style.animation='none';form.offsetHeight;form.style.animation='errorShake 0.4s ease';setTimeout(()=>form.style.animation='',400)}

function debounce(fn,delay){let timer;return function(...args){clearTimeout(timer);timer=setTimeout(()=>fn.apply(this,args),delay)}}

function simulateRequest(ms=1000){return new Promise((resolve,reject)=>{setTimeout(()=>{Math.random()>0.1?resolve():reject(new Error('Lỗi server. Vui lòng thử lại.'))},ms)})}

function initLoginForm(formId='loginForm'){
  const form=document.getElementById(formId);if(!form)return;
  const emailField=$('#loginEmail',form);const passwordField=$('#loginPassword',form);const submitBtn=form.querySelector('[type="submit"]');
  if(emailField){emailField.addEventListener('input',()=>validateField(emailField,[Rules.required,Rules.email],form));emailField.addEventListener('blur',()=>validateField(emailField,[Rules.required,Rules.email],form))}
  if(passwordField){passwordField.addEventListener('input',()=>validateField(passwordField,[Rules.required,Rules.minLen(6)],form));addPasswordToggle(passwordField)}
  form.addEventListener('submit',async(e)=>{e.preventDefault();const ok=validateField(emailField,[Rules.required,Rules.email],form)&&validateField(passwordField,[Rules.required,Rules.minLen(6)],form);if(!ok){Toast.error('Vui lòng kiểm tra lại thông tin.');shakeForm(form);return}setButtonLoading(submitBtn,true);try{await simulateRequest(1200);Toast.success('Đăng nhập thành công!');setTimeout(()=>{window.location.href=form.dataset.successUrl||'/'},1000)}catch(err){Toast.error(err.message||'Đăng nhập thất bại.')}finally{setButtonLoading(submitBtn,false)}});
}

function initRegisterForm(formId='registerForm'){
  const form=document.getElementById(formId);if(!form)return;
  const fields={fullName:{el:$('#regFullName',form),rules:[Rules.required,Rules.minLen(2),Rules.maxLen(60)]},username:{el:$('#regUsername',form),rules:[Rules.required,Rules.username]},email:{el:$('#regEmail',form),rules:[Rules.required,Rules.email]},phone:{el:$('#regPhone',form),rules:[]},password:{el:$('#regPassword',form),rules:[Rules.required,Rules.password]},confirm:{el:$('#regConfirm',form),rules:[Rules.required,Rules.match('#regPassword')]}};
  const submitBtn=form.querySelector('[type="submit"]');
  Object.values(fields).forEach(({el,rules})=>{if(!el)return;el.addEventListener('input',()=>validateField(el,rules,form));el.addEventListener('blur',()=>validateField(el,rules,form))});
  if(fields.password.el){addPasswordToggle(fields.password.el);fields.password.el.addEventListener('input',()=>updatePasswordStrength(fields.password.el.value,form))}
  if(fields.confirm.el)addPasswordToggle(fields.confirm.el);
  if(fields.username.el)addCharCounter(fields.username.el,20);
  form.addEventListener('submit',async(e)=>{e.preventDefault();let allValid=true;Object.values(fields).forEach(({el,rules})=>{if(el&&rules.length>0&&!validateField(el,rules,form))allValid=false});const terms=$('#regTerms',form);if(terms&&!terms.checked){Toast.warning('Bạn cần đồng ý với điều khoản sử dụng.');allValid=false}if(!allValid){Toast.error('Vui lòng kiểm tra lại các thông tin.');shakeForm(form);return}setButtonLoading(submitBtn,true);try{await simulateRequest(1500);Toast.success('Đăng ký thành công!');setTimeout(()=>{window.location.href=form.dataset.successUrl||'/login'},2000)}catch(err){Toast.error(err.message||'Đăng ký thất bại.')}finally{setButtonLoading(submitBtn,false)}});
}

function initContactForm(formId='contactForm'){
  const form=document.getElementById(formId);if(!form)return;
  const fields={name:{el:$('#contactName',form),rules:[Rules.required,Rules.minLen(2)]},email:{el:$('#contactEmail',form),rules:[Rules.required,Rules.email]},subject:{el:$('#contactSubject',form),rules:[Rules.required,Rules.minLen(5)]},message:{el:$('#contactMessage',form),rules:[Rules.required,Rules.minLen(20)]}};
  Object.values(fields).forEach(({el,rules})=>{if(!el)return;el.addEventListener('blur',()=>validateField(el,rules,form));el.addEventListener('input',()=>validateField(el,rules,form))});
  if(fields.message.el)addCharCounter(fields.message.el,2000);
  const submitBtn=form.querySelector('[type="submit"]');
  form.addEventListener('submit',async(e)=>{e.preventDefault();let allValid=true;Object.values(fields).forEach(({el,rules})=>{if(!validateField(el,rules,form))allValid=false});if(!allValid){Toast.error('Vui lòng điền đầy đủ thông tin.');shakeForm(form);return}setButtonLoading(submitBtn,true);try{await simulateRequest(1000);Toast.success('Tin nhắn đã được gửi!');form.reset()}catch{Toast.error('Gửi thất bại. Vui lòng thử lại.')}finally{setButtonLoading(submitBtn,false)}});
}

window.SV={Toast,validateField,Rules,initLoginForm,initRegisterForm,initContactForm,debounce};

/* ============================================================
   PLAYER STATE
============================================================ */
const Player={isPlaying:false,isShuffle:false,isRepeat:false,isMuted:false,isLoved:false,volume:80,progress:0,audio:new Audio()};

function togglePlay(){
  Player.isPlaying=!Player.isPlaying;
  document.getElementById('playerBar').classList.toggle('playing',Player.isPlaying);
  const cls=Player.isPlaying?'fa-pause':'fa-play';
  ['mainPlayIcon','npIcon','sidebarPlayIcon'].forEach(id=>{const el=document.getElementById(id);if(el)el.className='fas '+cls});
  if(Player.isPlaying){Player.audio.play?.().catch(()=>{});animateProgress()}else{Player.audio.pause?.()}
}

function animateProgress(){
  if(!Player.isPlaying)return;
  Player.progress=Math.min(Player.progress+0.05,100);
  const fill=document.getElementById('progressFill');const mini=document.getElementById('miniProgress');
  if(fill)fill.style.width=Player.progress+'%';if(mini)mini.style.width=Player.progress+'%';
  setTimeout(animateProgress,300);
}

function shuffleToggle(){Player.isShuffle=!Player.isShuffle;['shuffleBtn','shuffleBtn2'].forEach(id=>{const el=document.getElementById(id);if(el)el.classList.toggle('active',Player.isShuffle)})}
function repeatToggle(){Player.isRepeat=!Player.isRepeat;['repeatBtn','repeatBtn2'].forEach(id=>{const el=document.getElementById(id);if(el)el.classList.toggle('active',Player.isRepeat)})}
function toggleLove(){Player.isLoved=!Player.isLoved;const btn=document.getElementById('loveBtn');if(btn)btn.classList.toggle('loved',Player.isLoved)}
function setVolume(val){Player.volume=val;Player.audio.volume=val/100;const icon=document.getElementById('volIconI');if(!icon)return;icon.className=val==0?'fas fa-volume-xmark':val<40?'fas fa-volume-low':'fas fa-volume-high';['volumeSlider','mainVolume'].forEach(id=>{const el=document.getElementById(id);if(el)el.value=val})}
function toggleMute(){Player.isMuted=!Player.isMuted;Player.audio.muted=Player.isMuted;setVolume(Player.isMuted?0:Player.volume)}
function playerSeek(e){const track=document.getElementById('progressTrack');if(!track)return;const rect=track.getBoundingClientRect();Player.progress=((e.clientX-rect.left)/rect.width)*100;document.getElementById('progressFill').style.width=Player.progress+'%';const mini=document.getElementById('miniProgress');if(mini)mini.style.width=Player.progress+'%'}
function seekTo(e){const rect=e.currentTarget.getBoundingClientRect();Player.progress=((e.clientX-rect.left)/rect.width)*100;['progressFill','miniProgress'].forEach(id=>{const el=document.getElementById(id);if(el)el.style.width=Player.progress+'%'})}
function prevTrack(){Player.progress=0;['progressFill','miniProgress'].forEach(id=>{const el=document.getElementById(id);if(el)el.style.width='0%'})}
function nextTrack(){prevTrack()}
function toggleQueue(){}

function playSong(title,artist,coverUrl){
  document.getElementById('playerTitle').textContent=title||'Unknown';
  document.getElementById('playerArtist').textContent=artist||'--';
  document.getElementById('sidebarTitle').textContent=title||'Unknown';
  document.getElementById('sidebarArtist').textContent=artist||'--';
  const npBarTitle=document.getElementById('npBarTitle');if(npBarTitle)npBarTitle.textContent=title||'Unknown';
  const npBarArtist=document.getElementById('npBarArtist');if(npBarArtist)npBarArtist.textContent=artist||'--';
  const img=document.getElementById('playerCoverImg');const ph=document.getElementById('playerCoverPlaceholder');
  if(coverUrl){img.src=coverUrl;img.style.display='block';if(ph)ph.style.display='none'}
  Player.progress=0;['progressFill','miniProgress'].forEach(id=>{const el=document.getElementById(id);if(el)el.style.width='0%'});
  if(!Player.isPlaying)togglePlay();
}
window.playSong=playSong;

/* ============================================================
   SIDEBAR UI
============================================================ */
let sidebarCollapsed=false;
function toggleCollapse(){
  sidebarCollapsed=!sidebarCollapsed;
  document.getElementById('sidebar').classList.toggle('collapsed',sidebarCollapsed);
  const c=document.getElementById('mainContent');if(c)c.style.marginLeft=sidebarCollapsed?'68px':'var(--sidebar-w)';
}
function toggleSidebar(){
  const sb=document.getElementById('sidebar');const hb=document.getElementById('hamburger');
  sb.classList.toggle('mobile-open');hb.classList.toggle('active');
}
function createPlaylist(){const name=prompt('Tên playlist mới:');if(name&&name.trim()){Toast.success('Đã tạo playlist: '+name)}}

/* ============================================================
   GENRE NAVBAR & FILTER CHIPS
============================================================ */
document.querySelectorAll('.genre-tab').forEach(tab=>{
  tab.addEventListener('click',function(){document.querySelectorAll('.genre-tab').forEach(t=>t.classList.remove('active'));this.classList.add('active')})
});

function setView(mode,btn){
  document.querySelectorAll('.view-btn').forEach(b=>b.classList.remove('active'));btn.classList.add('active');
  const grid=document.getElementById('mainGrid');if(grid){grid.className=grid.className.replace(/view-\w+/g,'');grid.classList.add('view-'+mode)}
  localStorage.setItem('sv_view',mode);
}

function handleSort(value){const url=new URL(window.location.href);url.searchParams.set('sort',value);window.location.href=url.toString()}

function toggleChip(el,type,value){
  if(value==='all'){document.querySelectorAll('.chip').forEach(c=>c.classList.remove('active'));el.classList.add('active')}
  else{const allChip=document.querySelector('.chip[onclick*="all"]');if(allChip)allChip.classList.remove('active');el.classList.toggle('active')}
}

/* ============================================================
   SEARCH
============================================================ */
const debouncedSearch=debounce(function(val){if(!val||val.trim().length<2)return;if(val.length>100){const si=document.getElementById('globalSearch');if(si)setFieldState(si,'Từ khóa quá dài (tối đa 100 ký tự).')}},350);

/* ============================================================
   DOM READY
============================================================ */
document.addEventListener('DOMContentLoaded',()=>{
  initLoginForm();initRegisterForm();initContactForm();

  const gs=document.getElementById('globalSearch');
  if(gs){
    gs.addEventListener('input',e=>debouncedSearch(e.target.value));
    gs.addEventListener('keydown',e=>{
      if(e.key==='Enter'){e.preventDefault();const v=e.target.value.trim();if(v.length<2){Toast.warning('Nhập ít nhất 2 ký tự để tìm kiếm.');return}window.location.href='/search?q='+encodeURIComponent(v)}
      if(e.key==='Escape')e.target.blur();
    });
  }

  const saved=localStorage.getItem('sv_view');
  if(saved){const btn=document.querySelector(`.view-btn[onclick*="${saved}"]`);if(btn)setView(saved,btn)}

  const path=window.location.pathname;
  document.querySelectorAll('.nav-item').forEach(item=>{
    if(item.getAttribute('href')===path){document.querySelectorAll('.nav-item').forEach(i=>i.classList.remove('active'));item.classList.add('active')}
  });
});
</script>

</body>
</html>

