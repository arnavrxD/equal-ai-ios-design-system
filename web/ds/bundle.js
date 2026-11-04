/* @ds-bundle: {"format":4,"namespace":"EqualDS","components":[{"name":"Button"},{"name":"IconButton"},{"name":"Chip"},{"name":"Tag"},{"name":"Avatar"},{"name":"UnreadCount"},{"name":"Toggle"},{"name":"PlanRadio"},{"name":"Checkbox"},{"name":"CompareCheck"},{"name":"SectionLabel"},{"name":"PageDots"},{"name":"ProgressBar"},{"name":"TextField"},{"name":"ThinkingText"},{"name":"CrownLoader"},{"name":"Icon"},{"name":"SearchBar"},{"name":"ChatListItem"},{"name":"ChatBubble"},{"name":"Composer"},{"name":"QuickActionTile"},{"name":"SettingsRow"},{"name":"AssistantToggleCard"},{"name":"PlanCard"},{"name":"CouponRow"},{"name":"FAQItem"},{"name":"StatRow"},{"name":"PushBanner"},{"name":"GenderCard"},{"name":"AvailabilityPill"},{"name":"TrialPill"},{"name":"SheetHeader"},{"name":"UpiStep"},{"name":"KeyValueRow"},{"name":"AppHeader"},{"name":"TabBar"},{"name":"ChatList"},{"name":"EqualSheet"},{"name":"PermissionSheet"},{"name":"PromoCard"},{"name":"RecapCard"},{"name":"MembershipCard"},{"name":"ProfileHeader"},{"name":"ComparePlansTable"},{"name":"FeatureCard"},{"name":"StickyPlanSheet"},{"name":"PaywallHero"},{"name":"ValueRecapStory"},{"name":"AppStoreSheet"},{"name":"PaymentProcessing"},{"name":"SuccessState"},{"name":"EmptyState"},{"name":"OnboardingHeader"},{"name":"InviteCard"},{"name":"LiveCallCard"}]} */
(function () {
  var React = window.React, h = React.createElement, useState = React.useState;
  function cx() { return Array.prototype.filter.call(arguments, Boolean).join(' '); }

  /* Image assets uploaded to this system (asset store urls). */
  var A = {
    logo: 'assets/Logos/equal-ai-logo.svg',
    logoWhite: 'assets/Logos/equal-ai-logo-white.svg',
    crown: 'assets/Illustrations/crown.png',
    mascot: 'assets/Illustrations/mascot.png',
    mascotCrown: 'assets/Illustrations/mascot-crown.png',
    mascotWave: 'assets/Illustrations/mascot-wave.png',
    bell: 'assets/Illustrations/bell.png',
    gear: 'assets/Illustrations/gear.png',
    keshav: 'assets/Illustrations/avatar-male.png',
    female: 'assets/Illustrations/avatar-female.png',
    flagIndia: 'assets/Illustrations/flag-india.png',
    bank: 'assets/Illustrations/category-finance.png',
    rider: 'assets/Illustrations/category-ride.png',
    security: 'assets/Illustrations/category-delivery.png',
    others: 'assets/Illustrations/category-others.png',
    starAvatar: 'assets/Illustrations/avatar-male.png',
    callerPhone: 'assets/Illustrations/caller-phone.png',
    invite: 'assets/Illustrations/invite-hands.png',
    assistantBot: 'assets/Illustrations/assistant-bot.png'
  };

  /* ── Icons: redrawn line glyphs matching the SF Symbols / Material icons in the file ── */
  var P = {
    'chevron-right': 'M9 6l6 6-6 6',
    'chevron-down': 'M6 9l6 6 6-6',
    'chevron-left': 'M15 6l-6 6 6 6',
    close: 'M6 6l12 12M18 6L6 18',
    search: 'M11 4a7 7 0 1 0 0 14 7 7 0 0 0 0-14zM20 20l-4-4',
    check: 'M5 12.5l4.5 4.5L19 7.5',
    plus: 'M12 5v14M5 12h14',
    phone: 'M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z',
    mic: 'M12 3a3 3 0 0 0-3 3v6a3 3 0 0 0 6 0V6a3 3 0 0 0-3-3zM5 11a7 7 0 0 0 14 0M12 18v3',
    keyboard: 'M3 6h18v12H3zM7 10h.01M11 10h.01M15 10h.01M7 14h10',
    bell: 'M6 16V11a6 6 0 0 1 12 0v5l2 2H4zM10 20a2 2 0 0 0 4 0',
    'bell-slash': 'M6 16V11a6 6 0 0 1 9-5.2M18 11v5l2 2H8M10 20a2 2 0 0 0 4 0M4 4l16 16',
    doc: 'M7 3h7l4 4v14H7zM14 3v4h4M10 12h5M10 16h5',
    mic2: 'M12 3a3 3 0 0 0-3 3v6a3 3 0 0 0 6 0V6a3 3 0 0 0-3-3zM5 11a7 7 0 0 0 14 0',
    globe: 'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18zM3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18',
    shield: 'M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6z',
    message: 'M4 5h16v11H9l-5 4z',
    bolt: 'M13 3L5 14h6l-1 7 8-11h-6z',
    person: 'M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM5 20a7 7 0 0 1 14 0',
    more: 'M6 12h.01M12 12h.01M18 12h.01',
    wand: 'M4 20L15 9M15 4v3M18.5 5.5l-2 2M20 9h-3M13 6.5l1.5 1.5',
    gear: 'M12 9a3 3 0 1 0 0 6 3 3 0 0 0 0-6zM12 2v3M12 19v3M2 12h3M19 12h3M4.9 4.9l2.1 2.1M17 17l2.1 2.1M4.9 19.1L7 17M17 7l2.1-2.1',
    share: 'M12 4v11M8 8l4-4 4 4M5 14v5h14v-5',
    replay: 'M10 8l6 4-6 4z',
    support: 'M5 13v-1a7 7 0 0 1 14 0v1M5 13h2v5H5zM17 13h2v5h-2zM19 18a4 4 0 0 1-4 3h-2',
    face: 'M4 8V5a1 1 0 0 1 1-1h3M16 4h3a1 1 0 0 1 1 1v3M20 16v3a1 1 0 0 1-1 1h-3M8 20H5a1 1 0 0 1-1-1v-3M9 10v1M15 10v1M12 10v3h-1M9 16c2 1.5 4 1.5 6 0',
    calendar: 'M4 6h16v14H4zM4 10h16M8 3v4M16 3v4',
    pencil: 'M4 20l4-1 11-11-3-3L5 16zM14 6l3 3',
    chat: 'M12 4c5 0 9 3.2 9 7.2s-4 7.3-9 7.3c-1 0-2-.1-2.8-.4L4 20l1.4-3.7C3.9 15 3 13.2 3 11.2 3 7.2 7 4 12 4z',
    compass: 'M12 3a9 9 0 1 0 0 18 9 9 0 0 0 0-18zM15.5 8.5l-2 5-5 2 2-5z',
    grid: 'M6 7h.01M12 7h.01M18 7h.01M6 14h.01M12 14h.01M18 14h.01'
  };
  function Icon(p) {
    var size = p.size || 20, sw = p.strokeWidth || 1.8;
    return h('svg', { className: cx('eq-ico', p.className), width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', strokeWidth: sw, strokeLinecap: 'round', strokeLinejoin: 'round', 'aria-hidden': p.title ? undefined : true, role: p.title ? 'img' : undefined, style: p.style },
      p.title ? h('title', null, p.title) : null,
      h('path', { d: P[p.name] || P.more }));
  }
  /* The Equal mark: six dots in two rows (as in the logo), drawn for small fills. */
  function EqualMark(p) {
    var s = p.size || 24, c = p.color || 'currentColor';
    var dots = [[5, 8], [12, 8], [19, 8], [5, 16], [12, 16], [19, 16]];
    return h('svg', { width: s, height: s * 0.8, viewBox: '0 0 24 20', 'aria-hidden': true, className: 'eq-ico' },
      dots.map(function (d, i) { return h('ellipse', { key: i, cx: d[0], cy: d[1] - 2, rx: 3.6, ry: 3.2, fill: c }); }));
  }

  /* ───────── ATOMS ───────── */
  function Button(p) {
    var v = p.variant || 'primary', size = p.size || 'lg';
    return h('button', { type: p.type || 'button', disabled: p.disabled, onClick: p.onClick, className: cx('eq-btn', 'eq-btn-' + size, 'eq-btn-' + v, p.block && 'eq-btn-block', p.className) },
      p.icon ? h(Icon, { name: p.icon, size: size === 'lg' ? 20 : 14 }) : null, p.children);
  }
  function IconButton(p) {
    var v = p.variant || 'solid';
    return h('button', { type: 'button', 'aria-label': p.label, onClick: p.onClick, className: cx('eq-iconbtn', 'eq-iconbtn-' + v, p.className) },
      h(Icon, { name: p.icon || 'close', size: p.iconSize || (v === 'frost' ? 14 : 20), strokeWidth: 2 }));
  }
  function Chip(p) {
    var v = p.variant || 'neutral';
    return h('button', { type: 'button', onClick: p.onClick, className: cx('eq-chip', 'eq-chip-' + v, p.tall && 'eq-chip-tall', p.avatar && 'eq-chip-contact', p.className) },
      p.avatar || null,
      p.glyph ? h('span', { className: 'eq-chip-glyph', 'aria-hidden': true }, p.glyph) : null,
      p.icon ? h(Icon, { name: p.icon, size: 16 }) : null,
      h('span', null, p.children),
      p.chevron === false ? null : h(Icon, { name: 'chevron-right', size: 12, strokeWidth: 2.2, className: 'eq-chev' }));
  }
  function Tag(p) {
    var kind = p.kind || 'best';
    if (kind === 'gold') return h('span', { className: 'eq-tag eq-tag-gold' }, h('b', null, p.children || 'GOLD'));
    var cls = { status: 'eq-tag-status', expired: 'eq-tag-status expired', best: 'eq-tag-best', exclusive: 'eq-tag-exclusive', both: 'eq-tag-both', 'new': 'eq-tag-new', deal: 'eq-tag-deal', category: 'eq-tag-category' }[kind];
    return h('span', { className: cx('eq-tag', cls) }, p.children);
  }
  var AVATAR_TINT = { mint: 'var(--avatar-mint)', finance: 'var(--avatar-finance)', ride: 'var(--avatar-ride)', career: 'var(--avatar-career)', peach: 'var(--avatar-peach)', others: 'var(--avatar-others)', unknown: 'var(--avatar-unknown)' };
  function Avatar(p) {
    var s = p.size || 56;
    if (p.equal) return h('span', { className: 'eq-avatar eq-avatar-equal', style: { width: s, height: s } }, h(EqualMark, { size: s * 0.5, color: '#ffffff' }));
    return h('span', { className: 'eq-avatar', style: { width: s, height: s, background: AVATAR_TINT[p.tint || 'mint'], fontSize: s * 0.43 } },
      p.src ? h('img', { src: p.src, alt: p.alt || '' }) : p.initials,
      p.contact ? h('span', { className: 'eq-avatar-badge', title: 'Saved contact' }, h(Icon, { name: 'person', size: 12, strokeWidth: 2.2 })) : null);
  }
  function UnreadCount(p) {
    return p.dot ? h('span', { className: 'eq-count eq-count-dot', 'aria-label': 'Unread' }) : h('span', { className: 'eq-count', 'aria-label': p.count + ' unread' }, p.count);
  }
  function Toggle(p) {
    var st = useState(p.defaultChecked !== false), on = p.checked != null ? p.checked : st[0];
    return h('button', { type: 'button', role: 'switch', 'aria-checked': on, 'aria-label': p.label, className: 'eq-toggle', onClick: function () { st[1](!on); p.onChange && p.onChange(!on); } }, h('i'));
  }
  function PlanRadio(p) {
    return h('span', { className: cx('eq-radio', p.checked && 'on'), role: 'radio', 'aria-checked': !!p.checked }, p.checked ? h(Icon, { name: 'check', size: 12, strokeWidth: 3 }) : null);
  }
  function Checkbox(p) {
    var st = useState(!!p.defaultChecked), on = p.checked != null ? p.checked : st[0];
    return h('label', { style: { display: 'inline-flex', alignItems: 'center', gap: 7, fontSize: 12, color: 'var(--text-primary)', cursor: 'pointer' } },
      h('span', { className: cx('eq-check', on && 'on'), role: 'checkbox', 'aria-checked': on, tabIndex: 0, onClick: function () { st[1](!on); } }, on ? h(Icon, { name: 'check', size: 12, strokeWidth: 3 }) : null),
      p.children);
  }
  function CompareCheck() { return h('span', { className: 'eq-ccheck', 'aria-label': 'Included' }, h(Icon, { name: 'check', size: 12, strokeWidth: 2.6 })); }
  function SectionLabel(p) { return p.group ? h('div', { className: 'eq-grouplabel' }, p.children) : h('div', { className: cx('eq-section', p.tone === 'gold' && 'gold') }, p.children); }
  function PageDots(p) {
    var n = p.count || 5, a = p.active || 0, out = [];
    for (var i = 0; i < n; i++) out.push(h('i', { key: i, className: i === a ? 'on' : '' }));
    return h('span', { className: 'eq-dots', role: 'tablist', 'aria-label': 'Page ' + (a + 1) + ' of ' + n }, out);
  }
  function ProgressBar(p) { return h('div', { className: cx('eq-progress', p.tone === 'gold' && 'gold'), role: 'progressbar', 'aria-valuenow': p.value, 'aria-valuemin': 0, 'aria-valuemax': 100 }, h('i', { style: { width: (p.value || 0) + '%' } })); }
  function TextField(p) {
    var st = useState(p.defaultValue || ''), focus = useState(!!p.focused);
    return h('label', { className: cx('eq-field', (focus[0] || p.focused) && 'focus', p.align === 'center' && 'center') },
      p.prefix === 'phone' ? h('span', { className: 'eq-field-prefix' }, h('img', { src: A.flagIndia, alt: 'India' }), '+91') : null,
      p.prefix === 'phone' ? h('span', { className: 'eq-field-div' }) : null,
      h('input', { value: st[0], placeholder: p.placeholder, inputMode: p.prefix === 'phone' ? 'tel' : undefined, 'aria-label': p.label || p.placeholder,
        onChange: function (e) { st[1](e.target.value); }, onFocus: function () { focus[1](true); }, onBlur: function () { focus[1](!!p.focused); } }));
  }
  function ThinkingText(p) { return h('span', { className: 'eq-think' }, h('span', { className: 'eq-equaldot', style: { width: 24, height: 24 } }, h(EqualMark, { size: 13, color: '#ffffff' })), h('span', null, p.children || 'Thinking...')); }
  function CrownLoader(p) {
    var s = p.size || 80;
    return h('span', { className: 'eq-loader', style: { width: s, height: s }, role: 'status', 'aria-label': 'Processing' },
      h('svg', { viewBox: '0 0 80 80', width: s, height: s },
        h('circle', { cx: 40, cy: 40, r: 37, fill: 'none', stroke: 'rgba(0,0,0,.08)', strokeWidth: 4 }),
        h('circle', { cx: 40, cy: 40, r: 37, fill: 'none', stroke: '#a3712f', strokeWidth: 4, strokeLinecap: 'round', strokeDasharray: '58 175' })),
      h('img', { src: A.crown, alt: '' }));
  }

  /* ───────── MOLECULES ───────── */
  function SearchBar(p) {
    return h('div', { className: 'eq-search' },
      h('label', { className: 'eq-search-field' }, h(Icon, { name: 'search', size: 20, strokeWidth: 2 }), h('input', { placeholder: p.placeholder || 'Search for names', 'aria-label': 'Search chats' })),
      p.more === false ? null : h(IconButton, { variant: 'glass', icon: 'more', label: 'More options', iconSize: 24 }));
  }
  function ChatListItem(p) {
    var unread = p.unread > 0;
    return h('div', { className: 'eq-chat' },
      p.avatar || h(Avatar, { initials: p.initials, tint: p.tint, src: p.avatarSrc, contact: p.contact }),
      h('div', { className: 'eq-chat-body' },
        h('div', { className: 'eq-chat-top' },
          h('div', { className: 'eq-chat-text' }, h('div', { className: 'eq-chat-name' }, p.name), h('div', { className: 'eq-chat-msg' }, p.message)),
          h('div', { className: 'eq-chat-meta' }, h('span', { className: cx('eq-chat-time', unread && 'unread') }, p.time), unread ? h(UnreadCount, { count: p.unread }) : null)),
        p.actions && p.actions.length ? h('div', { className: 'eq-chat-actions' }, p.actions.map(function (a, i) { return h(Chip, { key: i, variant: unread ? 'suggested' : 'neutral', glyph: a.glyph, icon: a.icon }, a.label); })) : null));
  }
  function ChatBubble(p) {
    var from = p.from || 'assistant';
    var bubble = h('div', { className: cx('eq-bubble', from) },
      p.label !== false ? h('div', { className: 'eq-bubble-who' }, p.label || (from === 'user' ? 'You' : 'Equal AI')) : null,
      h('div', { className: 'eq-bubble-text' }, p.children),
      p.action ? h('div', { className: 'eq-bubble-action' }, '+ ', p.action) : null,
      h('span', { className: 'eq-bubble-time' }, p.time || '3:31 PM'));
    if (from === 'assistant' && p.withAvatar) return h('div', { className: 'eq-bubble-row' }, h('span', { className: 'eq-equaldot' }, h(EqualMark, { size: 14, color: '#ffffff' })), bubble);
    return bubble;
  }
  function Composer(p) {
    return h('div', { className: 'eq-composer' },
      p.typing ? h('div', { className: 'eq-composer-input', style: { width: 107 } }, 'Type...') : h(IconButton, { variant: 'tile', icon: 'keyboard', label: 'Type instead' }),
      h('button', { type: 'button', className: 'eq-btn eq-btn-voice' }, h(Icon, { name: 'mic', size: 18, strokeWidth: 2.2 }), p.label || 'Send voice note'));
  }
  function QuickActionTile(p) {
    return h('button', { type: 'button', className: cx('eq-qa', p.square && 'square') },
      h('span', { className: 'eq-qa-circle' }, p.mark ? h(EqualMark, { size: 30, color: 'var(--green)' }) : h(Icon, { name: p.icon || 'phone', size: p.square ? 28 : 32, strokeWidth: 1.9 })),
      h('span', { className: 'eq-qa-label' }, p.label));
  }
  function SettingsRow(p) {
    return h('button', { type: 'button', className: 'eq-row', onClick: p.onClick },
      h('span', { className: 'eq-row-main' },
        h('span', { className: 'eq-row-icon', style: { background: p.iconBg || 'transparent' } }, h(Icon, { name: p.icon || 'doc', size: 20 })),
        h('span', { className: 'eq-row-text' },
          h('span', { className: 'eq-row-title' }, p.title, p.badge ? h(Tag, { kind: 'new' }, p.badge) : null),
          p.subtitle ? h('span', { className: 'eq-row-sub' }, p.subtitle) : null)),
      h(Icon, { name: 'chevron-right', size: 16, strokeWidth: 2, className: 'eq-row-chev' }));
  }
  function SettingsGroup(p) { return h('div', { className: 'eq-group' }, p.children); }
  function AssistantToggleCard(p) {
    return h('div', { className: 'eq-assist' },
      h('img', { src: A.assistantBot, alt: '' }),
      h('div', { className: 'eq-assist-text' }, h('div', { className: 'eq-assist-title' }, p.title || 'AI Assistant is On'), h('div', { className: 'eq-assist-sub' }, p.subtitle || 'Equal is managing your unknown calls')),
      h(Toggle, { label: 'AI Assistant', defaultChecked: p.on !== false }));
  }
  function PlanCard(p) {
    return h('button', { type: 'button', className: cx('eq-plan', p.selected && 'on'), role: 'radio', 'aria-checked': !!p.selected, onClick: p.onSelect },
      h('span', { className: 'eq-plan-name' }, p.name),
      h('span', { className: 'eq-plan-price' }, p.price, h('small', null, p.period || '/month')),
      h(PlanRadio, { checked: p.selected }),
      p.best ? h(Tag, { kind: 'best' }, p.best === true ? 'Best value' : p.best) : null);
  }
  function CouponRow(p) {
    var st = useState(!!p.applied), on = st[0];
    return h('div', { className: cx('eq-coupon', on && 'applied') },
      h('span', { className: 'eq-coupon-seal', 'aria-hidden': true }, '%'),
      h('span', { className: 'eq-coupon-code' }, p.code || 'EQUAL25'),
      h('span', { className: 'eq-coupon-off' }, p.offer || 'FLAT 25% OFF'),
      h('button', { type: 'button', className: 'eq-coupon-apply', onClick: function () { st[1](!on); } }, on ? 'APPLIED' : 'APPLY'));
  }
  function FAQItem(p) {
    var st = useState(!!p.open);
    return h('div', { className: cx('eq-faq-item', st[0] && 'open') },
      h('button', { type: 'button', className: 'eq-faq-q', 'aria-expanded': st[0], onClick: function () { st[1](!st[0]); } }, h('span', null, p.question), h(Icon, { name: 'chevron-down', size: 22, strokeWidth: 2 })),
      st[0] ? h('div', { className: 'eq-faq-a' }, p.answer) : null);
  }
  function FAQ(p) { return h('div', { className: 'eq-faq' }, p.items.map(function (it, i) { return h(FAQItem, { key: i, question: it.q, answer: it.a, open: i === 0 && p.firstOpen }); })); }
  function StatRow(p) {
    return h('div', { className: 'eq-stat' },
      h('span', { className: 'eq-stat-icon' }, h(Icon, { name: p.icon || 'phone', size: 18 })),
      h('span', { className: 'eq-stat-label' }, p.label),
      h('span', { className: 'eq-stat-value' }, p.value));
  }
  function PushBanner(p) {
    return h('div', { className: 'eq-push', role: 'status' },
      h('span', { className: 'eq-push-icon', style: { background: 'var(--green)', display: 'flex', alignItems: 'center', justifyContent: 'center' }, role: 'img', 'aria-label': 'Equal AI' }, h(EqualMark, { size: 22, color: '#ffffff' })),
      h('div', { className: 'eq-push-body' },
        h('div', { className: 'eq-push-title' }, p.title, h('span', null, p.time || 'now')),
        h('div', { className: 'eq-push-text' }, p.children)));
  }
  function GenderCard(p) {
    return h('button', { type: 'button', role: 'radio', 'aria-checked': !!p.selected, className: cx('eq-gender', p.selected && 'on'), onClick: p.onSelect },
      h('span', null, p.label), h('img', { src: p.src || (p.label === 'Female' ? A.female : A.keshav), alt: '' }));
  }
  function AvailabilityPill(p) {
    return h('button', { type: 'button', className: cx('eq-avail', p.available === false && 'off') }, h('i'), p.available === false ? 'Busy' : 'Available', h(Icon, { name: 'chevron-down', size: 14, strokeWidth: 2.2 }));
  }
  function TrialPill(p) { return h('span', { className: 'eq-trialpill' }, h('img', { src: A.crown, alt: '' }), p.children || '1 Day Left'); }
  function SheetHeader(p) {
    return h('div', { className: 'eq-sheethead' },
      h('span', { className: 'eq-equaldot' }, h(EqualMark, { size: 14, color: '#ffffff' })),
      h('span', { className: 'eq-sheethead-title' }, p.title || 'Make a call'),
      h(IconButton, { variant: 'solid', icon: 'close', label: 'Close' }));
  }
  function UpiStep(p) { return h('div', { className: 'eq-step' }, h('span', { className: 'eq-step-num' }, p.n), h('span', { className: 'eq-step-text' }, p.children)); }
  function KeyValueRow(p) { return h('div', { className: 'eq-kv' }, h('dt', null, p.label), h('dd', null, p.value)); }

  /* ───────── ORGANISMS ───────── */
  function AppHeader(p) {
    return h('header', { className: 'eq-appbar' },
      h('span', { className: 'eq-appbar-brand' }, h('img', { src: A.logo, alt: 'equal ai' }), p.plan ? h(Tag, { kind: 'gold' }, p.plan) : null),
      p.right === 'avatar' ? h('span', { className: 'eq-appbar-avatar' }, h('img', { src: A.keshav, alt: 'Your profile' }))
        : p.right === 'trial' ? h(TrialPill, null, p.trialText) : h(AvailabilityPill, null));
  }
  function TabBar(p) {
    var st = useState(p.active || 'chats');
    function tab(id, label, icon) {
      return h('button', { key: id, type: 'button', className: cx('eq-tab', st[0] === id && 'on'), 'aria-pressed': st[0] === id, onClick: function () { st[1](id); } }, icon, label);
    }
    return h('nav', { className: 'eq-tabbar', 'aria-label': 'Main' },
      h('div', { className: 'eq-tabs' },
        tab('chats', 'Chats', h(Icon, { name: 'chat', size: 24, strokeWidth: 2 })),
        tab('you', 'You', h('img', { src: A.starAvatar, alt: '' })),
        p.badge ? h(UnreadCount, { count: p.badge }) : null),
      h('button', { type: 'button', className: 'eq-fab', 'aria-label': 'Talk to Equal' }, h(EqualMark, { size: 24, color: '#ffffff' })));
  }
  function ChatList(p) {
    var items = p.items || [];
    return h('div', { style: { display: 'flex', flexDirection: 'column', gap: 12, width: '100%' } },
      items.map(function (it, i) { return [i ? h('div', { key: 'd' + i, className: 'eq-divider' }) : null, h(ChatListItem, Object.assign({ key: 'c' + i }, it))]; }));
  }
  function EqualSheet(p) {
    return h('div', { className: 'eq-sheet', style: { background: 'var(--bg-surface)', gap: 16 } },
      h('span', { className: 'eq-handle' }),
      h('span', { className: 'eq-logo-disc' }, h(EqualMark, { size: 32, color: '#ffffff' })),
      h('div', null, h('div', { className: 'eq-greet' }, 'Good morning, ', h('em', null, p.name || 'Keshav')), h('div', { className: 'eq-greet-sub' }, 'What can I help you with today?')),
      h('div', { style: { display: 'flex', gap: 12 } },
        h(QuickActionTile, { square: true, mark: true, label: 'Talk to Equal' }),
        h(QuickActionTile, { square: true, icon: 'wand', label: 'Set Instruction' }),
        h(QuickActionTile, { square: true, icon: 'phone', label: 'Make a Call' })),
      h('div', { style: { display: 'flex', gap: 12, width: '100%', overflow: 'hidden' } },
        h(Chip, { variant: 'suggested', tall: true, glyph: '🗓️', chevron: false }, 'Reply Amit on WhatsApp'),
        h(Chip, { variant: 'suggested', tall: true, glyph: '🔔', chevron: false }, 'Set reminder')),
      h(Composer, null));
  }
  function PermissionSheet(p) {
    return h('div', { className: 'eq-sheet' },
      h(IconButton, { variant: 'solid', icon: 'close', label: 'Close', className: 'eq-sheet-close' }),
      h('div', { className: 'eq-sheet-art' }, h('img', { src: p.art || A.bell, alt: '' })),
      h('h3', { className: 'eq-sheet-title' }, p.title || 'Notification permission required'),
      h('p', { className: 'eq-sheet-body' }, p.body || 'Allow Equal AI to send you notifications to avoid missing important updates'),
      h('div', { className: 'eq-sheet-actions' },
        h(Button, { variant: 'primary', block: true, icon: 'gear' }, p.cta || 'Open settings'),
        p.secondary === false ? null : h(Button, { variant: 'link' }, p.secondary || 'Continue anyway')));
  }
  function PromoCard(p) {
    var k = p.kind || 'trial';
    if (k === 'trial') return h('div', { className: 'eq-promo eq-promo-trial' },
      h('div', { className: 'eq-promo-text' }, h('div', { className: 'eq-promo-title' }, p.title || 'Only 1 day of Gold left'), h('div', { className: 'eq-promo-sub' }, p.subtitle || 'From tomorrow, assistant stops answering calls.'),
        h(Button, { variant: 'goldpill', size: 'sm', className: 'eq-promo-cta' }, p.cta || 'Subscribe')),
      h('img', { className: 'art', src: A.crown, alt: '' }));
    if (k === 'gold') return h('div', { className: 'eq-promo eq-promo-gold' },
      h('span', { className: 'eq-dayring' }, p.days || 7),
      h('div', { className: 'eq-promo-text' }, h('div', { className: 'eq-promo-title' }, p.title || (p.days || 7) + ' days of Gold, on us'), h('div', { className: 'eq-promo-sub' }, p.subtitle || 'Everything is unlocked. Nothing to pay yet.')),
      h('img', { className: 'art', src: A.crown, alt: '', style: { width: 84, height: 84 } }));
    if (k === 'permissions') return h('div', { className: 'eq-promo eq-promo-perm' },
      h('div', { className: 'eq-promo-text' }, h('div', { className: 'eq-promo-title' }, 'Enable Permissions'), h('div', { className: 'eq-promo-sub' }, 'Allow notifications and contacts for real-time call recognition'),
        h(Button, { variant: 'goldpill', size: 'sm', icon: 'gear', className: 'eq-promo-cta' }, 'Open settings')),
      h('img', { className: 'art', src: A.gear, alt: '' }));
    return h('div', { className: 'eq-promo eq-promo-assist' },
      h('div', { className: 'eq-promo-text' }, h('div', { className: 'eq-promo-title' }, 'Meet Your Assistant'), h('div', { className: 'eq-promo-sub' }, 'Get to know your assistant better.'),
        h(Button, { variant: 'primary', size: 'md', icon: 'phone', className: 'eq-promo-cta' }, 'Call me')),
      h('img', { className: 'art', src: A.mascot, alt: '' }));
  }
  function RecapCard(p) {
    var s = p.stats || [['2h 22m', 'saved'], ['18', 'calls handled'], ['7', 'spam stopped']];
    return h('div', { className: 'eq-recap' },
      h('div', { className: 'eq-recap-eyebrow' }, p.eyebrow || 'Your free week with Equal', h(Icon, { name: 'replay', size: 12 })),
      h('div', { className: 'eq-recap-stats' }, s.map(function (x, i) { return h('div', { key: i, className: 'eq-recap-stat' }, h('b', null, x[0]), h('span', null, x[1])); })));
  }
  function MembershipCard(p) {
    var status = p.status || 'active';
    var label = { active: 'Active', trial: 'Free Trial', expired: 'Expired' }[status];
    return h('div', { className: 'eq-member' },
      h('div', { className: 'eq-member-main' },
        h('div', { className: 'eq-member-title' }, 'Equal', h('span', { className: 'gold' }, 'GOLD'), h(Tag, { kind: status === 'expired' ? 'expired' : 'status' }, label)),
        h('div', { className: 'eq-member-sub' }, p.subtitle || (status === 'trial' ? 'Trial ends in 1 day' : status === 'expired' ? 'Assistant has stopped handling your calls' : 'Auto renews May 16, 2026')),
        status === 'expired' ? h('button', { type: 'button', className: 'renew' }, 'Renew – ₹249/month') : null),
      p.price ? h('div', { className: 'eq-member-price' }, 'Price', h('b', null, p.price)) : h(Icon, { name: 'chevron-right', size: 18, strokeWidth: 2, style: { color: 'rgba(255,255,255,.7)' } }));
  }
  function ProfileHeader(p) {
    return h('div', { className: cx('eq-profile', p.expired && 'expired') },
      p.back ? h('span', { className: 'eq-profile-back' }, h(Icon, { name: 'chevron-left', size: 16, strokeWidth: 2.2 }), 'Settings') : null,
      h('img', { src: A.starAvatar, alt: '' }),
      h('div', null, h('div', { className: 'eq-profile-name' }, p.name || 'Keshav'), h('div', { className: 'eq-profile-phone' }, p.phone || '+91 98789 56749')));
  }
  var FEATURES = ['Call screening', 'Handles calls from contacts', 'Speaks your language', 'Instructions', 'Saved addresses', 'Post-call actions'];
  function ComparePlansTable(p) {
    var rows = p.features || FEATURES;
    return h('table', { className: 'eq-compare' },
      h('thead', null, h('tr', null, h('th', null, h('span', { className: 'eq-sr' }, 'Feature')), h('th', null, 'Gold'), h('th', { className: 'plus' }, 'Gold Plus'))),
      h('tbody', null,
        h('tr', { className: 'hl' }, h('th', { scope: 'row' }, 'AI calls a month'), h('td', null, h('b', null, p.goldCalls || '30')), h('td', { className: 'plus' }, h('span', { className: 'unl' }, 'Unlimited'))),
        rows.map(function (r, i) { return h('tr', { key: i }, h('th', { scope: 'row' }, r), h('td', null, h(CompareCheck)), h('td', { className: 'plus' }, h(CompareCheck))); })));
  }
  function FeatureCard(p) {
    var gold = p.exclusive !== false;
    return h('div', { className: cx('eq-feature', gold && 'gold') },
      h('div', { className: 'eq-feature-art' },
        p.art ? h('img', { src: p.art, alt: '' }) : h('img', { src: A.crown, alt: '' }),
        gold ? h('div', { className: 'eq-unlock' }, h('s', null, '30 calls a month'), h('i', null, '→'), h('span', null, 'Unlimited')) : null),
      h(Tag, { kind: gold ? 'exclusive' : 'both' }, gold ? 'Only in Gold Plus' : 'Both plans'),
      h('div', { className: 'eq-feature-text' }, h('div', { className: 'eq-feature-title' }, p.title || 'Unlimited AI calls'), h('div', { className: 'eq-feature-sub' }, p.subtitle || 'No monthly cap. Equal keeps calling for you all month, so you never wait for a reset.')));
  }
  function StickyPlanSheet(p) {
    var st = useState(p.selected || 'plus');
    var price = st[0] === 'plus' ? '₹499' : '₹249';
    return h('div', { className: 'eq-sticky' },
      h('div', { className: 'eq-plans', role: 'radiogroup', 'aria-label': 'Choose a plan' },
        h(PlanCard, { name: 'Gold', price: '₹249', selected: st[0] === 'gold', onSelect: function () { st[1]('gold'); } }),
        h(PlanCard, { name: 'Gold Plus', price: '₹499', best: true, selected: st[0] === 'plus', onSelect: function () { st[1]('plus'); } })),
      h(CouponRow, null),
      h('div', { className: 'eq-legal' }, p.note || 'Subscribing now ends your free trial immediately.'),
      h(Button, { variant: 'gold', block: true }, 'Get ' + (st[0] === 'plus' ? 'Gold Plus' : 'Gold') + ' for ' + price + '/month'),
      h('div', { className: 'eq-legal' }, 'Subscribe at ' + price + '/month. Cancel anytime in Settings.'),
      h('div', { className: 'eq-legal-links' }, h('span', null, 'Recurring billing'), h('span', null, 'Terms & Privacy'), h('span', null, 'Restore purchases')));
  }
  function PaywallHero(p) {
    return h('div', { className: 'eq-hero' },
      h('div', { className: 'eq-hero-bar' }, h(IconButton, { variant: 'frost', icon: 'close', label: 'Close' }), h('button', { type: 'button', className: 'eq-restore' }, 'Restore purchases')),
      h('img', { className: 'crown', src: A.crown, alt: '' }),
      h('div', { className: 'eq-hero-title' }, p.title || 'Choose your plan'),
      h('div', { className: 'eq-hero-sub' }, p.subtitle || h(React.Fragment, null, h('b', null, '1 day'), ' left in your free trial')));
  }
  function ValueRecapStory(p) {
    return h('div', { className: 'eq-story' },
      h(ProgressBar, { tone: 'gold', value: 45 }),
      h('div', { className: 'eq-story-top' }, h('button', { type: 'button', className: 'eq-story-skip' }, 'Skip')),
      h('div', { className: 'eq-story-eyebrow' }, (p.name || 'Keshav') + ', your free week with Equal'),
      h('div', { className: 'eq-story-hero' }, p.saved || '2h 22m'),
      h('div', { className: 'eq-story-sub' }, 'saved on calls you didn’t have to take'),
      h('div', null,
        h(StatRow, { icon: 'phone', label: 'Calls handled', value: 18 }),
        h(StatRow, { icon: 'shield', label: 'Spam and sales stopped', value: 7 }),
        h(StatRow, { icon: 'message', label: 'Messages taken', value: 5 }),
        h(StatRow, { icon: 'bolt', label: 'Actions after calls', value: 9 })),
      h('div', { className: 'eq-story-foot' }, 'Don’t make it ', h('em', null, 'start over.')));
  }
  function AppStoreSheet(p) {
    return h('div', { className: 'eq-appstore' },
      h('div', { className: 'eq-appstore-head' }, 'App Store', h(IconButton, { variant: 'frost', icon: 'close', label: 'Cancel' })),
      h('div', { className: 'eq-appstore-card' },
        h('div', { className: 'eq-appstore-app' }, h('span', { className: 'eq-appstore-icon' }, h(EqualMark, { size: 26, color: '#ffffff' })),
          h('div', null, h('div', { style: { fontSize: 17, fontWeight: 600 } }, p.product || 'Equal Gold Plus'), h('div', { style: { fontSize: 13, color: 'var(--ios-gray)' } }, 'Equal AI · Subscription'))),
        h('dl', { style: { margin: 0 } }, h(KeyValueRow, { label: 'Price', value: p.price || '₹499.00 per month' }), h(KeyValueRow, { label: 'Starts', value: 'Today' }), h(KeyValueRow, { label: 'Account', value: 'Apple Account' }))),
      h('div', { className: 'eq-appstore-note' }, p.note || 'Your free trial ends today and Gold Plus starts now. Renews monthly at ₹499 until cancelled in Settings.'),
      h('div', { className: 'eq-appstore-pay' }, h('i', null, h(Icon, { name: 'face', size: 30, strokeWidth: 1.6 })), 'Double-click side button to pay'));
  }
  function PaymentProcessing(p) {
    var steps = ['Open your UPI app, via notifications or directly', 'Review and approve the autopay request', 'Enter your UPI pin to confirm purchase', 'Come back to Equal AI app to continue'];
    var n = p.step || 1;
    return h('div', { className: 'eq-center eq-processing' },
      h(CrownLoader, { size: 80 }),
      h('div', null, h('div', { className: 'eq-center-title' }, 'Processing payment'), h('div', { className: 'eq-center-sub' }, 'Waiting for your confirmation...')),
      h('div', { className: 'eq-section', style: { margin: '8px 0' } }, 'Using UPI? Follow these steps:'),
      h(UpiStep, { n: n }, steps[n - 1]));
  }
  function SuccessState(p) {
    return h('div', { className: 'eq-center eq-success' },
      h('img', { src: A.mascotCrown, alt: '' }),
      p.trial ? h('div', null, h('div', { className: 'big' }, '7 days of'), h('div', { className: 'big gold' }, 'Equal Gold'), h('div', { className: 'eq-center-sub', style: { fontSize: 20 } }, 'Starts Today!'))
        : h('div', null, h('div', { className: 'kicker' }, 'Congratulations!'), h('div', { className: 'big' }, p.title || 'You’re on Gold Plus 🎉'), h('div', { className: 'eq-center-sub' }, p.subtitle || 'Unlimited AI calls start now')));
  }
  function EmptyState(p) {
    return h('div', { className: 'eq-center eq-empty' },
      h('img', { src: A.mascotWave, alt: '' }),
      h('div', { className: 'eq-center-title', style: { fontSize: 18 } }, p.title || 'Your chats will appear here'),
      h('div', { className: 'eq-center-sub' }, p.body || 'Talk to your assistant and try a demo of how it answers calls and helps you afterwards.'));
  }
  function OnboardingHeader(p) { return h('div', { className: 'eq-onb' }, h('h2', null, p.title), h('p', null, p.subtitle)); }
  function InviteCard() {
    return h('div', { className: 'eq-invite' },
      h('div', null, h('div', { className: 'eq-invite-title' }, 'Invite a Friend'), h('div', { className: 'eq-invite-sub' }, 'Give them the same superpower that you have'),
        h(Button, { variant: 'primary', size: 'md', icon: 'share' }, 'Share now')),
      h('img', { src: A.invite, alt: '' }));
  }
  function LiveCallCard(p) {
    return h('div', { className: 'eq-callcard' },
      h('div', { className: 'eq-callcard-top' }, h('img', { src: A.callerPhone, alt: '' }),
        h('div', { style: { flex: 1 } }, h('div', { className: 'eq-callcard-num' }, p.number || '+91 98765 43210'), h('div', { className: 'eq-callcard-timer' }, h('span', { style: { color: 'var(--green)' } }, '▮▮▮'), p.duration || '00:06')),
        h('img', { src: A.logo, alt: 'equal ai', style: { width: 68, height: 14 } })),
      h('div', { className: 'eq-callcard-status' }, p.status || 'Your assistant is on call.'),
      h('div', { className: 'eq-callcard-replies' }, (p.replies || ['Takeover', 'I’m Interested', 'Please, Call me later']).map(function (r, i) { return h('span', { key: i }, i === 0 ? h(Icon, { name: 'phone', size: 12 }) : null, r); })));
  }

  window.EqualDS = Object.assign(window.EqualDS || {}, {
    assets: A, EqualMark: EqualMark, Icon: Icon,
    Button: Button, IconButton: IconButton, Chip: Chip, Tag: Tag, Avatar: Avatar, UnreadCount: UnreadCount, Toggle: Toggle, PlanRadio: PlanRadio, Checkbox: Checkbox, CompareCheck: CompareCheck,
    SectionLabel: SectionLabel, PageDots: PageDots, ProgressBar: ProgressBar, TextField: TextField, ThinkingText: ThinkingText, CrownLoader: CrownLoader,
    SearchBar: SearchBar, ChatListItem: ChatListItem, ChatBubble: ChatBubble, Composer: Composer, QuickActionTile: QuickActionTile, SettingsRow: SettingsRow, SettingsGroup: SettingsGroup,
    AssistantToggleCard: AssistantToggleCard, PlanCard: PlanCard, CouponRow: CouponRow, FAQItem: FAQItem, FAQ: FAQ, StatRow: StatRow, PushBanner: PushBanner, GenderCard: GenderCard,
    AvailabilityPill: AvailabilityPill, TrialPill: TrialPill, SheetHeader: SheetHeader, UpiStep: UpiStep, KeyValueRow: KeyValueRow,
    AppHeader: AppHeader, TabBar: TabBar, ChatList: ChatList, EqualSheet: EqualSheet, PermissionSheet: PermissionSheet, PromoCard: PromoCard, RecapCard: RecapCard,
    MembershipCard: MembershipCard, ProfileHeader: ProfileHeader, ComparePlansTable: ComparePlansTable, FeatureCard: FeatureCard, StickyPlanSheet: StickyPlanSheet,
    PaywallHero: PaywallHero, ValueRecapStory: ValueRecapStory, AppStoreSheet: AppStoreSheet, PaymentProcessing: PaymentProcessing, SuccessState: SuccessState,
    EmptyState: EmptyState, OnboardingHeader: OnboardingHeader, InviteCard: InviteCard, LiveCallCard: LiveCallCard
  });
})();
