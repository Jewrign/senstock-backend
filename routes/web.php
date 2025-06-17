<?php

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Route;

Route::get('/test-db', function () {
    try {
        DB::connection()->getPdo();
        return '✅ Connexion PostgreSQL OK';
    } catch (\Exception $e) {
        return '❌ Erreur connexion DB : ' . $e->getMessage();
    }
});
