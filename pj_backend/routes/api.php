<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\ShipmentController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    // Public routes
    Route::post('/auth/register', [AuthController::class, 'register']);
    Route::post('/auth/login', [AuthController::class, 'login']);
    Route::get('/faqs', [\App\Http\Controllers\AdminController::class, 'faqs']);

    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/auth/logout', [AuthController::class, 'logout']);
        Route::get('/auth/me', [AuthController::class, 'me']);
        Route::patch('/auth/password', [AuthController::class, 'changePassword']);

        // Shipments
        Route::get('/shipments', [ShipmentController::class, 'index']);
        Route::post('/shipments', [ShipmentController::class, 'store']);
        Route::get('/shipments/{id}', [ShipmentController::class, 'show']);
        Route::post('/shipments/{id}/status', [ShipmentController::class, 'updateStatus']);
        Route::patch('/shipments/{id}/assign', [ShipmentController::class, 'assignDriver']);
        Route::get('/pricing/calculate', [ShipmentController::class, 'calculatePreview']);

        // Reports
        Route::get('/reports', [\App\Http\Controllers\ReportController::class, 'index']);
        Route::post('/reports', [\App\Http\Controllers\ReportController::class, 'store']);
        Route::post('/shipments/{id}/report', [\App\Http\Controllers\ReportController::class, 'store']);
        Route::put('/reports/{id}', [\App\Http\Controllers\ReportController::class, 'update']);
        Route::patch('/reports/{id}', [\App\Http\Controllers\ReportController::class, 'update']);

        // Notifications
        Route::get('/notifications', [\App\Http\Controllers\NotificationController::class, 'index']);
        Route::patch('/notifications/{id}/read', [\App\Http\Controllers\NotificationController::class, 'markAsRead']);
        Route::patch('/notifications/read-all', [\App\Http\Controllers\NotificationController::class, 'markAllAsRead']);

        // Staff Notifications
        Route::post('/staff/notifications/send', [\App\Http\Controllers\NotificationController::class, 'send']);
        Route::get('/staff/notifications/sent', [\App\Http\Controllers\NotificationController::class, 'sent']);
        Route::get('/staff/customers', [\App\Http\Controllers\NotificationController::class, 'customers']);
        Route::get('/staff/drivers', [ShipmentController::class, 'drivers']);

        // Admin Routes
        Route::middleware('role:super_admin')->group(function () {
            Route::get('/admin/users', [AdminController::class, 'users']);
            Route::post('/admin/users', [AdminController::class, 'storeUser']);
            Route::patch('/admin/users/{id}/toggle', [AdminController::class, 'toggleUserStatus']);

            Route::get('/admin/categories', [AdminController::class, 'categories']);
            Route::post('/admin/categories', [AdminController::class, 'storeCategory']);
            Route::patch('/admin/categories/{category}', [AdminController::class, 'updateCategory']);
            Route::delete('/admin/categories/{category}', [AdminController::class, 'destroyCategory']);

            Route::get('/admin/vehicles', [AdminController::class, 'vehicleTypes']);
            Route::post('/admin/vehicles', [AdminController::class, 'storeVehicleType']);
            Route::patch('/admin/vehicles/{vehicleType}', [AdminController::class, 'updateVehicleType']);
            Route::delete('/admin/vehicles/{vehicleType}', [AdminController::class, 'destroyVehicleType']);

            Route::get('/admin/pricing', [AdminController::class, 'pricing']);
            Route::patch('/admin/pricing', [AdminController::class, 'updatePricing']);

            Route::get('/admin/faq', [AdminController::class, 'faqs']);
            Route::post('/admin/faq', [AdminController::class, 'storeFaq']);
            Route::patch('/admin/faq/{faq}', [AdminController::class, 'updateFaq']);
            Route::delete('/admin/faq/{faq}', [AdminController::class, 'destroyFaq']);
        });
    });
});
