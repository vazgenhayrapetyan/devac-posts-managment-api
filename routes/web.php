<?php

use Illuminate\Support\Facades\Route;

use Illuminate\Support\Facades\Artisan;

Route::get('/run-setup-seeder', function () {
    try {
        // 1. Աշխատեցնում ենք միգրացիաները
        Artisan::call('migrate', ['--force' => true]);
        
        // 2. Աշխատեցնում ենք ձեր UserSeeder-ը
        Artisan::call('db:seed', [
            '--class' => 'UserSeeder',
            '--force' => true
        ]);
        
        return "<h1>Բազան հաջողությամբ լցվեց: Կարող եք մուտք գործել:</h1>";
    } catch (\Exception $e) {
        return "<h1>Սխալ առաջացավ.</h1> <pre>" . $e->getMessage() . "</pre>";
    }
});


Route::get('/', function () {
    return view('welcome');
});
