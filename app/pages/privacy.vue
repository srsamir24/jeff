<template>
  <div class="min-h-screen bg-paper dark:bg-charcoal transition-colors duration-300">
    <section class="section-padding pt-32 pb-20">
      <div class="max-w-3xl mx-auto">
        <p class="text-overline mb-6 opacity-60">Legal</p>
        <h1 class="text-5xl md:text-7xl font-bold tracking-tighter mb-16">
          Privacy Policy
        </h1>

        <div class="space-y-12 font-body text-charcoal/80 dark:text-paper/70 leading-relaxed">
          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">1. Introduction</h2>
            <p>
              Anna Ericyan ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you visit our website.
            </p>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">2. Information We Collect</h2>
            <p class="mb-4">We may collect the following types of information:</p>
            <ul class="list-disc pl-6 space-y-2">
              <li><strong>Personal Information:</strong> Name, email address, and any details you provide through our contact form.</li>
              <li><strong>Usage Data:</strong> IP address, browser type, pages visited, and time spent on the site.</li>
              <li><strong>Cookies:</strong> Small data files stored on your device to enhance your browsing experience.</li>
            </ul>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">3. How We Use Your Information</h2>
            <p class="mb-4">We use the collected information to:</p>
            <ul class="list-disc pl-6 space-y-2">
              <li>Respond to your inquiries and provide client support.</li>
              <li>Improve our website and services.</li>
              <li>Send occasional updates about our work (only with your consent).</li>
              <li>Analyze site traffic and user behavior.</li>
            </ul>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">4. Data Security</h2>
            <p>
              We implement appropriate technical and organizational measures to protect your personal data against unauthorized access, alteration, or destruction. However, no internet transmission is completely secure.
            </p>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">5. Third-Party Services</h2>
            <p>
              We may use trusted third-party services (such as analytics and hosting providers) that process data on our behalf. These providers are bound by confidentiality agreements and data protection regulations.
            </p>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">6. Your Rights</h2>
            <p class="mb-4">You have the right to:</p>
            <ul class="list-disc pl-6 space-y-2">
              <li>Access the personal data we hold about you.</li>
              <li>Request correction or deletion of your data.</li>
              <li>Withdraw consent for marketing communications at any time.</li>
            </ul>
          </div>

          <div>
            <h2 class="font-display text-2xl font-semibold text-charcoal dark:text-paper mb-4">7. Contact Us</h2>
            <p>
              If you have any questions about this Privacy Policy, please contact us at
              <a href="mailto:hello@annaericyan.com" class="underline hover:text-neon-teal transition-colors">hello@annaericyan.com</a>.
            </p>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
useHead({
  title: 'Privacy Policy — Anna Ericyan',
  meta: [
    { name: 'robots', content: 'noindex, follow' }
  ]
})
</script>
