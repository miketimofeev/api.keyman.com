<?php declare(strict_types=1);

namespace Keyman\Site\com\keyman\api\tests;

require_once(__DIR__ . '/../tools/base.inc.php');
require_once(__DIR__ . '/../script/windows/14.0/update/WindowsUpdateCheck.php');
require_once(__DIR__ . '/ApiTestCase.php');
require_once(__DIR__ . '/TestUtils.inc.php');

use Keyman\Site\com\keyman\api\tests\ApiTestCase;

final class WindowsUpdateCheckTest extends ApiTestCase
{
  private const SchemaFilename = "/windows-update/14.0/windows-update.json";

  public function testSimpleResultValidatesAgainstSchema(): void
  {
    $schema = TestUtils::LoadJSONSchema(self::SchemaFilename);

    $u = new \Keyman\Site\com\keyman\api\WindowsUpdateCheck();
    $json = $u->execute('alpha', '14.0.100', ['khmer_angkor'=>'1.0.2', 'foo'=>'0.1'], 0);
    $this->assertNotEmpty($json);
    $data = json_decode($json);
    $this->assertNotNull($data);

    // This will throw an exception if it does not pass
    $schema->in($data);

    // TODO: add some more realism!
    $this->assertJsonStringEqualsJsonFile(__DIR__ . '/fixtures/WindowsUpdateCheck.14.0.json', $json);
  }
}