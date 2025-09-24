'use strict';

(function() {
	const DEFAULT_LANG = localStorage.getItem('lang') || (navigator.language?.startsWith('es') ? 'es' : 'en');
	const langSelect = document.getElementById('langSelect');
	if (langSelect) {
		langSelect.value = DEFAULT_LANG;
		langSelect.addEventListener('change', () => {
			localStorage.setItem('lang', langSelect.value);
			location.reload();
		});
	}

	async function fetchJSON(path) {
		const res = await fetch(path + '?v=' + Date.now());
		if (!res.ok) throw new Error('HTTP ' + res.status + ' for ' + path);
		return await res.json();
	}

	function setText(el, text) {
		if (el) el.textContent = text || '';
	}

	function createEl(tag, className, html) {
		const el = document.createElement(tag);
		if (className) el.className = className;
		if (html) el.innerHTML = html;
		return el;
	}

	function renderChips(list, container) {
		container.innerHTML = '';
		(list || []).forEach((item) => {
			const li = document.createElement('li');
			li.textContent = item;
			container.appendChild(li);
		});
	}

	function renderCards(items, container) {
		container.innerHTML = '';
		(items || []).forEach((it) => {
			const card = createEl('div', 'card');
			const title = createEl('h3');
			title.textContent = it.title || '';
			const meta = createEl('div', 'meta');
			meta.textContent = [it.company, it.period].filter(Boolean).join(' • ');
			const desc = createEl('p');
			desc.textContent = it.description || '';
			card.appendChild(title);
			card.appendChild(meta);
			card.appendChild(desc);
			container.appendChild(card);
		});
	}

	function applyI18n(dict) {
		document.querySelectorAll('[data-i18n]').forEach((el) => {
			const key = el.getAttribute('data-i18n');
			if (dict[key]) el.textContent = dict[key];
		});
	}

	async function main() {
		const lang = DEFAULT_LANG;
		const [profile, i18n] = await Promise.all([
			fetchJSON('data/profile.json'),
			fetchJSON('i18n/' + lang + '.json')
		]);

		applyI18n(i18n);
		setText(document.getElementById('name'), profile.name);
		setText(document.getElementById('role'), profile.role[lang] || profile.role.en);
		setText(document.getElementById('about'), profile.about[lang] || profile.about.en);

		const skillsEl = document.getElementById('skills');
		if (skillsEl) renderChips(profile.skills, skillsEl);

		renderCards(profile.experience?.map((e) => ({
			title: e.title[lang] || e.title.en,
			company: e.company,
			period: e.period,
			description: e.description[lang] || e.description.en
		})), document.getElementById('experience'));

		renderCards(profile.education?.map((e) => ({
			title: e.title[lang] || e.title.en,
			company: e.school,
			period: e.period,
			description: e.description?.[lang] || e.description?.en
		})), document.getElementById('education'));

		renderCards(profile.projects?.map((p) => ({
			title: p.name,
			company: p.stack?.join(', '),
			period: p.year,
			description: p.description[lang] || p.description.en
		})), document.getElementById('projects'));

		const contact = profile.contact || {};
		const contactEl = document.getElementById('contact');
		if (contactEl) {
			const parts = [];
			if (contact.email) parts.push(`<a href="mailto:${contact.email}">Email</a>`);
			if (contact.phone) parts.push(`<span>${contact.phone}</span>`);
			if (contact.location) parts.push(`<span>${contact.location}</span>`);
			if (contact.links) {
				Object.entries(contact.links).forEach(([k, v]) => parts.push(`<a href="${v}" target="_blank" rel="noreferrer noopener">${k}</a>`));
			}
			contactEl.innerHTML = parts.join(' • ');
		}
	}

	main().catch((err) => {
		console.error(err);
		const mainEl = document.querySelector('main');
		if (mainEl) {
			const alert = createEl('div', 'card', 'Error cargando contenido. Revisa la consola.');
			mainEl.prepend(alert);
		}
	});
})();
