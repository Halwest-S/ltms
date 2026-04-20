<?php

namespace App\Services;

use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class ProductLinkService
{
    /**
     * Validate a marketplace product URL and return normalized product metadata.
     *
     * This service is intentionally small and deterministic. It detects the
     * platform and extracts safe metadata from the URL itself; richer scraping
     * can be added later behind the same contract without changing controllers.
     */
    public function preview(string $url): array
    {
        $url = trim($url);

        if (! filter_var($url, FILTER_VALIDATE_URL)) {
            $this->fail('Enter a valid Amazon or Alibaba product URL.');
        }

        $parts = parse_url($url);
        $host = strtolower($parts['host'] ?? '');
        $path = $parts['path'] ?? '';

        if ($this->isAmazonHost($host)) {
            return $this->previewAmazon($url, $host, $path);
        }

        if ($this->isAlibabaHost($host)) {
            return $this->previewAlibaba($url, $path);
        }

        $this->fail('Only Amazon and Alibaba product links are supported.');
    }

    private function previewAmazon(string $url, string $host, string $path): array
    {
        $externalId = null;

        if ($host === 'amzn.to') {
            return $this->payload(
                platform: 'amazon',
                platformLabel: 'Amazon',
                url: $url,
                externalId: null,
                title: null,
            );
        }

        foreach ([
            '~/(?:dp|gp/product|product)/([A-Z0-9]{10})(?:[/?]|$)~i',
            '~/gp/aw/d/([A-Z0-9]{10})(?:[/?]|$)~i',
        ] as $pattern) {
            if (preg_match($pattern, $path, $matches) === 1) {
                $externalId = strtoupper($matches[1]);
                break;
            }
        }

        if ($externalId === null) {
            $this->fail('The Amazon link must point to a product page.');
        }

        return $this->payload(
            platform: 'amazon',
            platformLabel: 'Amazon',
            url: $url,
            externalId: $externalId,
            title: $this->titleFromAmazonPath($path),
        );
    }

    private function previewAlibaba(string $url, string $path): array
    {
        $isProductPath = str_contains($path, '/product-detail/')
            || str_contains($path, '/product/')
            || str_contains($path, '/item/');

        if (! $isProductPath) {
            $this->fail('The Alibaba link must point to a product page.');
        }

        $externalId = null;
        if (preg_match('~_(\d+)\.html$~', $path, $matches) === 1) {
            $externalId = $matches[1];
        }

        return $this->payload(
            platform: 'alibaba',
            platformLabel: 'Alibaba',
            url: $url,
            externalId: $externalId,
            title: $this->titleFromAlibabaPath($path),
        );
    }

    private function payload(
        string $platform,
        string $platformLabel,
        string $url,
        ?string $externalId,
        ?string $title,
    ): array {
        return [
            'platform' => $platform,
            'platform_label' => $platformLabel,
            'url' => $url,
            'external_id' => $externalId,
            'title' => $title,
            'image_url' => null,
            'price' => null,
        ];
    }

    private function isAmazonHost(string $host): bool
    {
        return $host === 'amzn.to'
            || str_contains($host, 'amazon.');
    }

    private function isAlibabaHost(string $host): bool
    {
        return $host === 'alibaba.com'
            || str_ends_with($host, '.alibaba.com');
    }

    private function titleFromAmazonPath(string $path): ?string
    {
        $segments = array_values(array_filter(explode('/', trim($path, '/'))));
        $dpIndex = array_search('dp', $segments, true);

        if ($dpIndex === false || $dpIndex === 0) {
            return null;
        }

        return $this->humanizeSlug($segments[$dpIndex - 1]);
    }

    private function titleFromAlibabaPath(string $path): ?string
    {
        $segments = array_values(array_filter(explode('/', trim($path, '/'))));
        $slug = end($segments);

        if (! is_string($slug) || $slug === '') {
            return null;
        }

        $slug = preg_replace('~_\d+\.html$~', '', $slug) ?? $slug;

        return $this->humanizeSlug($slug);
    }

    private function humanizeSlug(string $slug): ?string
    {
        $text = preg_replace('~[-_]+~', ' ', urldecode($slug)) ?? '';
        $text = trim($text);

        return $text === '' ? null : Str::title($text);
    }

    private function fail(string $message): never
    {
        throw ValidationException::withMessages([
            'product_url' => [$message],
        ]);
    }
}
