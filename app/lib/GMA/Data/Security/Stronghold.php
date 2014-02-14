<?php namespace GMA\Data\Security;

use Crypt;

/**
 * Provides a stronghold for top secret / highly identifying information such
 * as account passwords, PINs, and SSNs.  This keeps data encrypted at rest.
 */
class Stronghold
{
    
    /**
     * The contents of the stronghold
     * @var array
     */
    protected $items;

    /**
     * Are the contents currently encrypted?
     * @var boolean
     */
    protected $encrypted;

    /**
     * Initializing constructor dumps items into the Stronghold
     * @param array $items
     */
    public function __construct($items)
    {
        $this->encrypted = false;

        if (is_null($items) && !is_array($items)) {
            $this->items = array();
        }
        
        $this->items = $items;
        $this->iterator('isEncrypted', function () {

        });
    }

    /**
     * Calls the wrath of the decryption method through the items iterator
     * and returns the decrypted array
     * @return array Decrypted items
     */
    public function decryptAll()
    {
        if ($this->encrypted) {
            $this->iterator("decrypt", function () {
                $this->encrypted = false;
            });
        }
        return $this;
    }

    /**
     * Calls the encryption method through the items iterator and returns
     * the encrypted array
     * @return array Encrypted values
     */
    public function encryptAll()
    {
        if (!$this->encrypted) {
            $this->iterator("encrypt", function () {
                $this->encrypted = true;
            });
        }
        return $this;
    }

    /**
     * Runs the iterator with the specified callable method then runs the callback
     * @param  string $method   Class method to run in iteration
     * @param  Closure $callback Call this closure on completion
     * @return $closure()
     */
    private function iterator ($method, $callback)
    {
        if (array_walk_recursive($this->items, array($this, $method))) {
            return $callback();
        }
    }

    /**
     * Method for calling through the iterator that encrypts each value on the
     * items collection _BY REFERENCE_
     * @param  mixed $value Value to be encrypted
     * @param  integer $index Index on the array
     * @return void
     */
    protected function encrypt(&$value, $index)
    {
        if (is_string($value) || is_numeric($value)) {
            $value = Crypt::encrypt($value);
        } else {
            throw new Exception();
        }
    }

    /**
     * Method for calling through the iterator that decrypts each value
     * on the items collection _BY REFERENCE_
     * @param  mixed $value Value to be decrypted
     * @param  integer $index Index on items collection
     * @return void
     */
    protected function decrypt(&$value, $index)
    {
        $value = Crypt::decrypt($value);
    }
    
    protected function isEncrypted(&$value, $index)
    {
        if (is_string($value)) {
            if (strlen($value) > 20) {
                $this->encrypted = true;
            }
        }
    }

    public function toArray()
    {
        return $this->items;
    }
}
